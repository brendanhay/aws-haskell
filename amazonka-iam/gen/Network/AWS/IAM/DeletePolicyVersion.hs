{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DeriveGeneric      #-}
{-# LANGUAGE OverloadedStrings  #-}
{-# LANGUAGE RecordWildCards    #-}
{-# LANGUAGE TypeFamilies       #-}

{-# OPTIONS_GHC -fno-warn-unused-binds   #-}
{-# OPTIONS_GHC -fno-warn-unused-matches #-}

-- Derived from AWS service descriptions, licensed under Apache 2.0.

-- |
-- Module      : Network.AWS.IAM.DeletePolicyVersion
-- Copyright   : (c) 2013-2015 Brendan Hay
-- License     : Mozilla Public License, v. 2.0.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : experimental
-- Portability : non-portable (GHC extensions)
--
-- Deletes the specified version of the specified managed policy.
--
-- You cannot delete the default version of a policy using this API. To
-- delete the default version of a policy, use DeletePolicy. To find out
-- which version of a policy is marked as the default version, use
-- ListPolicyVersions.
--
-- For information about versions for managed policies, refer to
-- <http://docs.aws.amazon.com/IAM/latest/UserGuide/policies-managed-versions.html Versioning for Managed Policies>
-- in the /Using IAM/ guide.
--
-- <http://docs.aws.amazon.com/IAM/latest/APIReference/API_DeletePolicyVersion.html>
module Network.AWS.IAM.DeletePolicyVersion
    (
    -- * Request
      DeletePolicyVersion
    -- ** Request constructor
    , deletePolicyVersion
    -- ** Request lenses
    , dpvPolicyARN
    , dpvVersionId

    -- * Response
    , DeletePolicyVersionResponse
    -- ** Response constructor
    , deletePolicyVersionResponse
    ) where

import           Network.AWS.IAM.Types
import           Network.AWS.Prelude
import           Network.AWS.Request
import           Network.AWS.Response

-- | /See:/ 'deletePolicyVersion' smart constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'dpvPolicyARN'
--
-- * 'dpvVersionId'
data DeletePolicyVersion = DeletePolicyVersion'
    { _dpvPolicyARN :: !Text
    , _dpvVersionId :: !Text
    } deriving (Eq,Read,Show,Data,Typeable,Generic)

-- | 'DeletePolicyVersion' smart constructor.
deletePolicyVersion :: Text -> Text -> DeletePolicyVersion
deletePolicyVersion pPolicyARN_ pVersionId_ =
    DeletePolicyVersion'
    { _dpvPolicyARN = pPolicyARN_
    , _dpvVersionId = pVersionId_
    }

-- | FIXME: Undocumented member.
dpvPolicyARN :: Lens' DeletePolicyVersion Text
dpvPolicyARN = lens _dpvPolicyARN (\ s a -> s{_dpvPolicyARN = a});

-- | The policy version to delete.
--
-- For more information about managed policy versions, see
-- <http://docs.aws.amazon.com/IAM/latest/UserGuide/policies-managed-versions.html Versioning for Managed Policies>
-- in the /Using IAM/ guide.
dpvVersionId :: Lens' DeletePolicyVersion Text
dpvVersionId = lens _dpvVersionId (\ s a -> s{_dpvVersionId = a});

instance AWSRequest DeletePolicyVersion where
        type Sv DeletePolicyVersion = IAM
        type Rs DeletePolicyVersion =
             DeletePolicyVersionResponse
        request = postQuery
        response = receiveNull DeletePolicyVersionResponse'

instance ToHeaders DeletePolicyVersion where
        toHeaders = const mempty

instance ToPath DeletePolicyVersion where
        toPath = const "/"

instance ToQuery DeletePolicyVersion where
        toQuery DeletePolicyVersion'{..}
          = mconcat
              ["Action" =: ("DeletePolicyVersion" :: ByteString),
               "Version" =: ("2010-05-08" :: ByteString),
               "PolicyArn" =: _dpvPolicyARN,
               "VersionId" =: _dpvVersionId]

-- | /See:/ 'deletePolicyVersionResponse' smart constructor.
data DeletePolicyVersionResponse =
    DeletePolicyVersionResponse'
    deriving (Eq,Read,Show,Data,Typeable,Generic)

-- | 'DeletePolicyVersionResponse' smart constructor.
deletePolicyVersionResponse :: DeletePolicyVersionResponse
deletePolicyVersionResponse = DeletePolicyVersionResponse'
