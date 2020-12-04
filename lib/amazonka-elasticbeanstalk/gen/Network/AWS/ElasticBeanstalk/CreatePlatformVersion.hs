{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TypeFamilies #-}
{-# OPTIONS_GHC -fno-warn-unused-binds #-}
{-# OPTIONS_GHC -fno-warn-unused-imports #-}
{-# OPTIONS_GHC -fno-warn-unused-matches #-}

-- Derived from AWS service descriptions, licensed under Apache 2.0.

-- |
-- Module      : Network.AWS.ElasticBeanstalk.CreatePlatformVersion
-- Copyright   : (c) 2013-2020 Brendan Hay
-- License     : Mozilla Public License, v. 2.0.
-- Maintainer  : Brendan Hay <brendan.g.hay+amazonka@gmail.com>
-- Stability   : auto-generated
-- Portability : non-portable (GHC extensions)
--
-- Create a new version of your custom platform.
module Network.AWS.ElasticBeanstalk.CreatePlatformVersion
  ( -- * Creating a Request
    createPlatformVersion,
    CreatePlatformVersion,

    -- * Request Lenses
    cpvOptionSettings,
    cpvEnvironmentName,
    cpvTags,
    cpvPlatformName,
    cpvPlatformVersion,
    cpvPlatformDefinitionBundle,

    -- * Destructuring the Response
    createPlatformVersionResponse,
    CreatePlatformVersionResponse,

    -- * Response Lenses
    cpvrsBuilder,
    cpvrsPlatformSummary,
    cpvrsResponseStatus,
  )
where

import Network.AWS.ElasticBeanstalk.Types
import Network.AWS.Lens
import Network.AWS.Prelude
import Network.AWS.Request
import Network.AWS.Response

-- | Request to create a new platform version.
--
--
--
-- /See:/ 'createPlatformVersion' smart constructor.
data CreatePlatformVersion = CreatePlatformVersion'
  { _cpvOptionSettings ::
      !(Maybe [ConfigurationOptionSetting]),
    _cpvEnvironmentName :: !(Maybe Text),
    _cpvTags :: !(Maybe [Tag]),
    _cpvPlatformName :: !Text,
    _cpvPlatformVersion :: !Text,
    _cpvPlatformDefinitionBundle :: !S3Location
  }
  deriving (Eq, Read, Show, Data, Typeable, Generic)

-- | Creates a value of 'CreatePlatformVersion' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'cpvOptionSettings' - The configuration option settings to apply to the builder environment.
--
-- * 'cpvEnvironmentName' - The name of the builder environment.
--
-- * 'cpvTags' - Specifies the tags applied to the new platform version. Elastic Beanstalk applies these tags only to the platform version. Environments that you create using the platform version don't inherit the tags.
--
-- * 'cpvPlatformName' - The name of your custom platform.
--
-- * 'cpvPlatformVersion' - The number, such as 1.0.2, for the new platform version.
--
-- * 'cpvPlatformDefinitionBundle' - The location of the platform definition archive in Amazon S3.
createPlatformVersion ::
  -- | 'cpvPlatformName'
  Text ->
  -- | 'cpvPlatformVersion'
  Text ->
  -- | 'cpvPlatformDefinitionBundle'
  S3Location ->
  CreatePlatformVersion
createPlatformVersion
  pPlatformName_
  pPlatformVersion_
  pPlatformDefinitionBundle_ =
    CreatePlatformVersion'
      { _cpvOptionSettings = Nothing,
        _cpvEnvironmentName = Nothing,
        _cpvTags = Nothing,
        _cpvPlatformName = pPlatformName_,
        _cpvPlatformVersion = pPlatformVersion_,
        _cpvPlatformDefinitionBundle = pPlatformDefinitionBundle_
      }

-- | The configuration option settings to apply to the builder environment.
cpvOptionSettings :: Lens' CreatePlatformVersion [ConfigurationOptionSetting]
cpvOptionSettings = lens _cpvOptionSettings (\s a -> s {_cpvOptionSettings = a}) . _Default . _Coerce

-- | The name of the builder environment.
cpvEnvironmentName :: Lens' CreatePlatformVersion (Maybe Text)
cpvEnvironmentName = lens _cpvEnvironmentName (\s a -> s {_cpvEnvironmentName = a})

-- | Specifies the tags applied to the new platform version. Elastic Beanstalk applies these tags only to the platform version. Environments that you create using the platform version don't inherit the tags.
cpvTags :: Lens' CreatePlatformVersion [Tag]
cpvTags = lens _cpvTags (\s a -> s {_cpvTags = a}) . _Default . _Coerce

-- | The name of your custom platform.
cpvPlatformName :: Lens' CreatePlatformVersion Text
cpvPlatformName = lens _cpvPlatformName (\s a -> s {_cpvPlatformName = a})

-- | The number, such as 1.0.2, for the new platform version.
cpvPlatformVersion :: Lens' CreatePlatformVersion Text
cpvPlatformVersion = lens _cpvPlatformVersion (\s a -> s {_cpvPlatformVersion = a})

-- | The location of the platform definition archive in Amazon S3.
cpvPlatformDefinitionBundle :: Lens' CreatePlatformVersion S3Location
cpvPlatformDefinitionBundle = lens _cpvPlatformDefinitionBundle (\s a -> s {_cpvPlatformDefinitionBundle = a})

instance AWSRequest CreatePlatformVersion where
  type Rs CreatePlatformVersion = CreatePlatformVersionResponse
  request = postQuery elasticBeanstalk
  response =
    receiveXMLWrapper
      "CreatePlatformVersionResult"
      ( \s h x ->
          CreatePlatformVersionResponse'
            <$> (x .@? "Builder")
            <*> (x .@? "PlatformSummary")
            <*> (pure (fromEnum s))
      )

instance Hashable CreatePlatformVersion

instance NFData CreatePlatformVersion

instance ToHeaders CreatePlatformVersion where
  toHeaders = const mempty

instance ToPath CreatePlatformVersion where
  toPath = const "/"

instance ToQuery CreatePlatformVersion where
  toQuery CreatePlatformVersion' {..} =
    mconcat
      [ "Action" =: ("CreatePlatformVersion" :: ByteString),
        "Version" =: ("2010-12-01" :: ByteString),
        "OptionSettings"
          =: toQuery (toQueryList "member" <$> _cpvOptionSettings),
        "EnvironmentName" =: _cpvEnvironmentName,
        "Tags" =: toQuery (toQueryList "member" <$> _cpvTags),
        "PlatformName" =: _cpvPlatformName,
        "PlatformVersion" =: _cpvPlatformVersion,
        "PlatformDefinitionBundle" =: _cpvPlatformDefinitionBundle
      ]

-- | /See:/ 'createPlatformVersionResponse' smart constructor.
data CreatePlatformVersionResponse = CreatePlatformVersionResponse'
  { _cpvrsBuilder ::
      !(Maybe Builder),
    _cpvrsPlatformSummary ::
      !(Maybe PlatformSummary),
    _cpvrsResponseStatus :: !Int
  }
  deriving (Eq, Read, Show, Data, Typeable, Generic)

-- | Creates a value of 'CreatePlatformVersionResponse' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'cpvrsBuilder' - The builder used to create the custom platform.
--
-- * 'cpvrsPlatformSummary' - Detailed information about the new version of the custom platform.
--
-- * 'cpvrsResponseStatus' - -- | The response status code.
createPlatformVersionResponse ::
  -- | 'cpvrsResponseStatus'
  Int ->
  CreatePlatformVersionResponse
createPlatformVersionResponse pResponseStatus_ =
  CreatePlatformVersionResponse'
    { _cpvrsBuilder = Nothing,
      _cpvrsPlatformSummary = Nothing,
      _cpvrsResponseStatus = pResponseStatus_
    }

-- | The builder used to create the custom platform.
cpvrsBuilder :: Lens' CreatePlatformVersionResponse (Maybe Builder)
cpvrsBuilder = lens _cpvrsBuilder (\s a -> s {_cpvrsBuilder = a})

-- | Detailed information about the new version of the custom platform.
cpvrsPlatformSummary :: Lens' CreatePlatformVersionResponse (Maybe PlatformSummary)
cpvrsPlatformSummary = lens _cpvrsPlatformSummary (\s a -> s {_cpvrsPlatformSummary = a})

-- | -- | The response status code.
cpvrsResponseStatus :: Lens' CreatePlatformVersionResponse Int
cpvrsResponseStatus = lens _cpvrsResponseStatus (\s a -> s {_cpvrsResponseStatus = a})

instance NFData CreatePlatformVersionResponse