{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DeriveGeneric      #-}
{-# LANGUAGE OverloadedStrings  #-}
{-# LANGUAGE RecordWildCards    #-}
{-# LANGUAGE TypeFamilies       #-}

{-# OPTIONS_GHC -fno-warn-unused-binds   #-}
{-# OPTIONS_GHC -fno-warn-unused-matches #-}

-- Derived from AWS service descriptions, licensed under Apache 2.0.

-- |
-- Module      : Network.AWS.IAM.CreateSAMLProvider
-- Copyright   : (c) 2013-2015 Brendan Hay
-- License     : Mozilla Public License, v. 2.0.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : experimental
-- Portability : non-portable (GHC extensions)
--
-- Creates an IAM entity to describe an identity provider (IdP) that
-- supports SAML 2.0.
--
-- The SAML provider that you create with this operation can be used as a
-- principal in a role\'s trust policy to establish a trust relationship
-- between AWS and a SAML identity provider. You can create an IAM role
-- that supports Web-based single sign-on (SSO) to the AWS Management
-- Console or one that supports API access to AWS.
--
-- When you create the SAML provider, you upload an a SAML metadata
-- document that you get from your IdP and that includes the issuer\'s
-- name, expiration information, and keys that can be used to validate the
-- SAML authentication response (assertions) that are received from the
-- IdP. You must generate the metadata document using the identity
-- management software that is used as your organization\'s IdP.
--
-- This operation requires
-- <http://docs.aws.amazon.com/general/latest/gr/signature-version-4.html Signature Version 4>.
--
-- For more information, see
-- <http://docs.aws.amazon.com/STS/latest/UsingSTS/STSMgmtConsole-SAML.html Giving Console Access Using SAML>
-- and
-- <http://docs.aws.amazon.com/STS/latest/UsingSTS/CreatingSAML.html Creating Temporary Security Credentials for SAML Federation>
-- in the /Using Temporary Credentials/ guide.
--
-- <http://docs.aws.amazon.com/IAM/latest/APIReference/API_CreateSAMLProvider.html>
module Network.AWS.IAM.CreateSAMLProvider
    (
    -- * Request
      CreateSAMLProvider
    -- ** Request constructor
    , createSAMLProvider
    -- ** Request lenses
    , csamlpSAMLMetadataDocument
    , csamlpName

    -- * Response
    , CreateSAMLProviderResponse
    -- ** Response constructor
    , createSAMLProviderResponse
    -- ** Response lenses
    , csamlprsSAMLProviderARN
    , csamlprsStatus
    ) where

import           Network.AWS.IAM.Types
import           Network.AWS.Prelude
import           Network.AWS.Request
import           Network.AWS.Response

-- | /See:/ 'createSAMLProvider' smart constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'csamlpSAMLMetadataDocument'
--
-- * 'csamlpName'
data CreateSAMLProvider = CreateSAMLProvider'
    { _csamlpSAMLMetadataDocument :: !Text
    , _csamlpName                 :: !Text
    } deriving (Eq,Read,Show,Data,Typeable,Generic)

-- | 'CreateSAMLProvider' smart constructor.
createSAMLProvider :: Text -> Text -> CreateSAMLProvider
createSAMLProvider pSAMLMetadataDocument_ pName_ =
    CreateSAMLProvider'
    { _csamlpSAMLMetadataDocument = pSAMLMetadataDocument_
    , _csamlpName = pName_
    }

-- | An XML document generated by an identity provider (IdP) that supports
-- SAML 2.0. The document includes the issuer\'s name, expiration
-- information, and keys that can be used to validate the SAML
-- authentication response (assertions) that are received from the IdP. You
-- must generate the metadata document using the identity management
-- software that is used as your organization\'s IdP.
--
-- For more information, see
-- <http://docs.aws.amazon.com/STS/latest/UsingSTS/CreatingSAML.html Creating Temporary Security Credentials for SAML Federation>
-- in the /Using Temporary Security Credentials/ guide.
csamlpSAMLMetadataDocument :: Lens' CreateSAMLProvider Text
csamlpSAMLMetadataDocument = lens _csamlpSAMLMetadataDocument (\ s a -> s{_csamlpSAMLMetadataDocument = a});

-- | The name of the provider to create.
csamlpName :: Lens' CreateSAMLProvider Text
csamlpName = lens _csamlpName (\ s a -> s{_csamlpName = a});

instance AWSRequest CreateSAMLProvider where
        type Sv CreateSAMLProvider = IAM
        type Rs CreateSAMLProvider =
             CreateSAMLProviderResponse
        request = postQuery
        response
          = receiveXMLWrapper "CreateSAMLProviderResult"
              (\ s h x ->
                 CreateSAMLProviderResponse' <$>
                   (x .@? "SAMLProviderArn") <*> (pure (fromEnum s)))

instance ToHeaders CreateSAMLProvider where
        toHeaders = const mempty

instance ToPath CreateSAMLProvider where
        toPath = const "/"

instance ToQuery CreateSAMLProvider where
        toQuery CreateSAMLProvider'{..}
          = mconcat
              ["Action" =: ("CreateSAMLProvider" :: ByteString),
               "Version" =: ("2010-05-08" :: ByteString),
               "SAMLMetadataDocument" =:
                 _csamlpSAMLMetadataDocument,
               "Name" =: _csamlpName]

-- | Contains the response to a successful CreateSAMLProvider request.
--
-- /See:/ 'createSAMLProviderResponse' smart constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'csamlprsSAMLProviderARN'
--
-- * 'csamlprsStatus'
data CreateSAMLProviderResponse = CreateSAMLProviderResponse'
    { _csamlprsSAMLProviderARN :: !(Maybe Text)
    , _csamlprsStatus          :: !Int
    } deriving (Eq,Read,Show,Data,Typeable,Generic)

-- | 'CreateSAMLProviderResponse' smart constructor.
createSAMLProviderResponse :: Int -> CreateSAMLProviderResponse
createSAMLProviderResponse pStatus_ =
    CreateSAMLProviderResponse'
    { _csamlprsSAMLProviderARN = Nothing
    , _csamlprsStatus = pStatus_
    }

-- | The Amazon Resource Name (ARN) of the SAML provider.
csamlprsSAMLProviderARN :: Lens' CreateSAMLProviderResponse (Maybe Text)
csamlprsSAMLProviderARN = lens _csamlprsSAMLProviderARN (\ s a -> s{_csamlprsSAMLProviderARN = a});

-- | FIXME: Undocumented member.
csamlprsStatus :: Lens' CreateSAMLProviderResponse Int
csamlprsStatus = lens _csamlprsStatus (\ s a -> s{_csamlprsStatus = a});
