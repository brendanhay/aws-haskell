-- |
-- Module      : Gen.Transform
-- Copyright   : (c) 2013-2020 Brendan Hay
-- License     : This Source Code Form is subject to the terms of
--               the Mozilla Public License, v. 2.0.
--               A copy of the MPL can be found in the LICENSE file or
--               you can obtain it at http://mozilla.org/MPL/2.0/.
-- Maintainer  : Brendan Hay <brendan.g.hay+amazonka@gmail.com>
-- Stability   : provisional
-- Portability : non-portable (GHC extensions)
module Gen.Transform where

import Control.Arrow ((&&&))
import qualified Control.Lens as Lens
import qualified Control.Monad.Except as Except
import qualified Control.Monad.State.Strict as State
import qualified Data.Foldable as Foldable
import qualified Data.Graph as Graph
import qualified Data.HashMap.Strict.InsOrd as HashMap
import qualified Data.HashSet as HashSet
import qualified Data.Maybe as Maybe
import qualified Data.Text as Text
import qualified Data.Tree as Tree
import GHC.Exts (toList)
import Gen.Prelude
import Gen.Syntax.Data
import Gen.Transform.Cofree
import Gen.Transform.Override
import Gen.Transform.Prefix
import Gen.Transform.Substitute
import Gen.Types

-- FIXME: Relations need to be updated by the solving step.

rewrite ::
  Versions ->
  Config ->
  Service Maybe (RefF ()) (ShapeF ()) (Waiter Id) ->
  Either String Library
rewrite versions cfg svc = do
  let expanded =
        svc & shapes
          %~ if _newtypeStringLiterals cfg
            then newtypeStrings
            else id

  rewritten <- rewriteService cfg (deprecateOperations expanded)
  rendered <- renderShapes cfg rewritten

  pure $! Library versions cfg rendered $
    serviceData (rendered ^. metadata) (rendered ^. retry)

deprecateOperations :: Service f a b c -> Service f a b c
deprecateOperations = operations %~ HashMap.filter (not . Lens.view opDeprecated)

rewriteService ::
  Config ->
  Service Maybe (RefF ()) (ShapeF ()) (Waiter Id) ->
  Either String (Service Identity (RefF ()) (Shape Related) (Waiter Id))
rewriteService cfg s = do
  -- Determine which direction (input, output, or both) shapes are used.
  rs <- determineRelations (s ^. operations) (s ^. shapes)
  -- Elaborate the shape map into a comonadic strucutre for traversing.
  elaborate (s ^. shapes)
    -- Annotate the comonadic tree with the associated
    -- bi/unidirectional (input/output/both) relation for shapes.
    >>= traverse (pure . attach Related rs)
    -- Apply the override configuration to the service, and default any
    -- optional fields from the JSON where needed.
    >>= pure . (\ss -> override (cfg ^. typeOverrides) (s {_shapes = ss}))
    -- Ensure no empty operation references exist, and that operation shapes
    -- are considered 'unique', so they can be lifted into the operation's
    -- module, separately from .Types.
    >>= substitute

renderShapes ::
  Config ->
  Service Identity (RefF ()) (Shape Related) (Waiter Id) ->
  Either String (Service Identity SData SData WData)
renderShapes cfg svc = do
  -- Generate unique prefixes for struct (product) members and
  -- enum (sum) branches to avoid ambiguity.
  (x, y) <-
    prefixes (svc ^. shapes)
      -- Determine the appropriate Haskell AST type, auto deriveable instances,
      -- and fully rendered instances.
      >>= pure . solveShapes cfg
      -- Separate the operation input/output shapes from the .Types shapes.
      >>= separateOperations (svc ^. operations)

  -- Prune anything that is an orphan, or not an exception
  let prune = HashMap.filter (\s -> not (isOrphan s) || s ^. infoException)

  -- Convert shape ASTs into a rendered Haskell AST declaration,
  xs <- traverse (operationData cfg svc) x

  let ys = HashMap.mapMaybe (shapeData svc) (prune y)

  zs <- HashMap.traverseWithKey (waiterData svc x) (svc ^. waiters)

  pure
    $! svc
      { _operations = xs,
        _shapes = ys,
        _waiters = zs
      }

type MemoR = StateT (InsOrdHashMap Id Relation, HashSet (Id, Direction, Id)) (Either String)

-- | Determine the relation for operation payloads, both input and output.
--
-- /Note:/ This currently doesn't operate Lens.over the free AST, since it's also
-- used by 'setDefaults'.
determineRelations ::
  Show a =>
  InsOrdHashMap Id (Operation Maybe (RefF b) c) ->
  InsOrdHashMap Id (ShapeF a) ->
  Either String (InsOrdHashMap Id Relation)
determineRelations os ss =
  fst <$> State.execStateT (traverse go os) (mempty, mempty)
  where
    -- FIXME: opName here is incorrect as a parent.
    go :: Operation Maybe (RefF a) b -> MemoR ()
    go o =
      count Nothing Input (o ^? opInput . Lens._Just . refShape)
        >> count Nothing Output (o ^? opOutput . Lens._Just . refShape)

    count :: Maybe Id -> Direction -> Maybe Id -> MemoR ()
    count _ _ Nothing = pure ()
    count p d (Just n) = do
      Lens._1 %= HashMap.insertWith (<>) n (mkRelation p d)

      check p d n $ do
        s <- lift (safe n)
        shape n d s

    shape :: Id -> Direction -> ShapeF a -> MemoR ()
    shape p d =
      mapM_ (count (Just p) d . Just . Lens.view refShape)
        . Lens.toListOf references

    -- Ensure cyclic dependencies are only checked once per direction/parent.
    check Nothing _ _ f = f
    check (Just p) d n f = do
      let k = (p, d, n)
      m <- Lens.uses Lens._2 (HashSet.member k)
      if m
        then pure ()
        else Lens._2 %= HashSet.insert k >> f

    safe n =
      case HashMap.lookup n ss of
        Nothing ->
          Left $
            "Missing shape "
              ++ show n
              ++ " when counting relations "
              ++ ", possible matches: "
              ++ show (partial n ss)
        Just ok ->
          Right ok

-- FIXME: Necessary to update the Relation?
solveShapes ::
  Traversable t =>
  Config ->
  t (Shape Prefixed) ->
  t (Shape Solved)
solveShapes cfg ss =
  State.evalState (go ss) (replaced typeOf cfg)
  where
    go = traverse (annotate Solved id (pure . typeOf))

    replaced :: (Replace -> a) -> Config -> InsOrdHashMap Id a
    replaced f =
      HashMap.fromList
        . map (_replaceName &&& f)
        . HashMap.elems
        . vMapMaybe _replacedBy
        . _typeOverrides

type MemoS a = StateT (InsOrdHashMap Id a) (Either String)

-- | Create a newtype wrapper for all top-level string literals and struct fields.
newtypeStrings ::
  InsOrdHashMap Id (ShapeF ()) ->
  InsOrdHashMap Id (ShapeF ())
newtypeStrings shapes =
  State.execState (HashMap.traverseWithKey replaceShape shapes) shapes
  where
    replaceShape key = \case
      Struct struct -> do
        members' <- HashMap.traverseWithKey replaceField (_members struct)

        State.modify' $
          HashMap.insert key (Struct (struct & members .~ members'))
      --
      Lit info Text ->
        unless (isSimpleName key) $
          State.modify' $
            HashMap.insert key (emptyEnum emptyInfo)
      --
      _other ->
        pure ()

    replaceField label ref
      | isSimpleName (_refShape ref) = pure ref
      | otherwise = do
        let key = _refShape ref
            new = mkId (typeId label)

        State.gets (HashMap.lookup key) >>= \case
          -- We're pointing at something we know how to replace.
          Just (Lit info Text)
            | not (isSimpleName key) ->
              State.gets (HashMap.lookup new) >>= \case
                -- Never seen this identifier before in my life.
                Nothing -> do
                  State.modify' $
                    HashMap.insert new (emptyEnum emptyInfo)

                  pure ref {_refShape = new}
                -- An empty pattern (newtype) we've inserted previously.
                Just (Enum info values)
                  | info == emptyInfo && HashMap.null values ->
                    pure ref {_refShape = new}
                -- A raw string literal that's safe to replace.
                Just (Lit info Text)
                  | info == emptyInfo ->
                    pure ref {_refShape = new}
                -- Lost, confused, and don't know how to newtype this, continue.
                Just _ ->
                  pure ref
          -- Otherwise, just return the unmodified (un-newtyped) ref.
          _other ->
            pure ref

    isSimpleName (memberId -> name) =
      Text.toLower name == "String"
        || Text.isPrefixOf "__" name

    emptyEnum =
      flip Enum mempty

    emptyInfo =
      Info
        { _infoDocumentation = Nothing,
          _infoMin = Nothing,
          _infoMax = Nothing,
          _infoPattern = Nothing,
          _infoTimestamp = Nothing,
          _infoFlattened = False,
          _infoSensitive = False,
          _infoStreaming = False,
          _infoException = False,
          _infoError = Nothing
        }

-- | Filter the ids representing operation input/outputs from the supplied map,
-- and attach the associated shape to the appropriate operation.
--
-- Returns either an error result or the operations paired with
-- the respective data types.
separateOperations ::
  (Show a, HasRelation a, Show b) =>
  InsOrdHashMap Id (Operation Identity (RefF b) c) ->
  InsOrdHashMap Id a ->
  Either String (InsOrdHashMap Id (Operation Identity (RefF a) c), InsOrdHashMap Id a)
separateOperations os =
  State.runStateT (traverse go os)
  where
    go ::
      (HasRelation b, Show a, Show b) =>
      Operation Identity (RefF a) c ->
      MemoS b (Operation Identity (RefF b) c)
    go o = do
      x <- remove Input (inputName o)
      y <- remove Output (outputName o)

      pure
        $! o
          { _opInput = Identity (o ^. opInput . _Identity & refAnn .~ x),
            _opOutput = Identity (o ^. opOutput . _Identity & refAnn .~ y)
          }

    remove :: HasRelation a => Direction -> Id -> MemoS a a
    remove d n = do
      s <- State.get

      case HashMap.lookup n s of
        Nothing ->
          Except.throwError $
            "Failure separating operation wrapper "
              ++ show n
              ++ " from "
              ++ show (HashMap.map (const ()) s)
        --
        Just x -> do
          when (d == Input || not (isShared x)) $
            State.modify' (HashMap.delete n)

          pure x