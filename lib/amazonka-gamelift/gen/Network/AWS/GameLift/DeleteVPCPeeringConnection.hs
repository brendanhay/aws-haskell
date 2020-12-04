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
-- Module      : Network.AWS.GameLift.DeleteVPCPeeringConnection
-- Copyright   : (c) 2013-2020 Brendan Hay
-- License     : Mozilla Public License, v. 2.0.
-- Maintainer  : Brendan Hay <brendan.g.hay+amazonka@gmail.com>
-- Stability   : auto-generated
-- Portability : non-portable (GHC extensions)
--
-- Removes a VPC peering connection. To delete the connection, you must have a valid authorization for the VPC peering connection that you want to delete. You can check for an authorization by calling 'DescribeVpcPeeringAuthorizations' or request a new one using 'CreateVpcPeeringAuthorization' .
--
--
-- Once a valid authorization exists, call this operation from the AWS account that is used to manage the Amazon GameLift fleets. Identify the connection to delete by the connection ID and fleet ID. If successful, the connection is removed.
--
--     * 'CreateVpcPeeringAuthorization'
--
--     * 'DescribeVpcPeeringAuthorizations'
--
--     * 'DeleteVpcPeeringAuthorization'
--
--     * 'CreateVpcPeeringConnection'
--
--     * 'DescribeVpcPeeringConnections'
--
--     * 'DeleteVpcPeeringConnection'
module Network.AWS.GameLift.DeleteVPCPeeringConnection
  ( -- * Creating a Request
    deleteVPCPeeringConnection,
    DeleteVPCPeeringConnection,

    -- * Request Lenses
    dvpcFleetId,
    dvpcVPCPeeringConnectionId,

    -- * Destructuring the Response
    deleteVPCPeeringConnectionResponse,
    DeleteVPCPeeringConnectionResponse,

    -- * Response Lenses
    dvpcrsResponseStatus,
  )
where

import Network.AWS.GameLift.Types
import Network.AWS.Lens
import Network.AWS.Prelude
import Network.AWS.Request
import Network.AWS.Response

-- | Represents the input for a request operation.
--
--
--
-- /See:/ 'deleteVPCPeeringConnection' smart constructor.
data DeleteVPCPeeringConnection = DeleteVPCPeeringConnection'
  { _dvpcFleetId ::
      !Text,
    _dvpcVPCPeeringConnectionId :: !Text
  }
  deriving (Eq, Read, Show, Data, Typeable, Generic)

-- | Creates a value of 'DeleteVPCPeeringConnection' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'dvpcFleetId' - A unique identifier for a fleet. This fleet specified must match the fleet referenced in the VPC peering connection record. You can use either the fleet ID or ARN value.
--
-- * 'dvpcVPCPeeringConnectionId' - A unique identifier for a VPC peering connection. This value is included in the 'VpcPeeringConnection' object, which can be retrieved by calling 'DescribeVpcPeeringConnections' .
deleteVPCPeeringConnection ::
  -- | 'dvpcFleetId'
  Text ->
  -- | 'dvpcVPCPeeringConnectionId'
  Text ->
  DeleteVPCPeeringConnection
deleteVPCPeeringConnection pFleetId_ pVPCPeeringConnectionId_ =
  DeleteVPCPeeringConnection'
    { _dvpcFleetId = pFleetId_,
      _dvpcVPCPeeringConnectionId = pVPCPeeringConnectionId_
    }

-- | A unique identifier for a fleet. This fleet specified must match the fleet referenced in the VPC peering connection record. You can use either the fleet ID or ARN value.
dvpcFleetId :: Lens' DeleteVPCPeeringConnection Text
dvpcFleetId = lens _dvpcFleetId (\s a -> s {_dvpcFleetId = a})

-- | A unique identifier for a VPC peering connection. This value is included in the 'VpcPeeringConnection' object, which can be retrieved by calling 'DescribeVpcPeeringConnections' .
dvpcVPCPeeringConnectionId :: Lens' DeleteVPCPeeringConnection Text
dvpcVPCPeeringConnectionId = lens _dvpcVPCPeeringConnectionId (\s a -> s {_dvpcVPCPeeringConnectionId = a})

instance AWSRequest DeleteVPCPeeringConnection where
  type
    Rs DeleteVPCPeeringConnection =
      DeleteVPCPeeringConnectionResponse
  request = postJSON gameLift
  response =
    receiveEmpty
      ( \s h x ->
          DeleteVPCPeeringConnectionResponse' <$> (pure (fromEnum s))
      )

instance Hashable DeleteVPCPeeringConnection

instance NFData DeleteVPCPeeringConnection

instance ToHeaders DeleteVPCPeeringConnection where
  toHeaders =
    const
      ( mconcat
          [ "X-Amz-Target"
              =# ("GameLift.DeleteVpcPeeringConnection" :: ByteString),
            "Content-Type" =# ("application/x-amz-json-1.1" :: ByteString)
          ]
      )

instance ToJSON DeleteVPCPeeringConnection where
  toJSON DeleteVPCPeeringConnection' {..} =
    object
      ( catMaybes
          [ Just ("FleetId" .= _dvpcFleetId),
            Just ("VpcPeeringConnectionId" .= _dvpcVPCPeeringConnectionId)
          ]
      )

instance ToPath DeleteVPCPeeringConnection where
  toPath = const "/"

instance ToQuery DeleteVPCPeeringConnection where
  toQuery = const mempty

-- | /See:/ 'deleteVPCPeeringConnectionResponse' smart constructor.
newtype DeleteVPCPeeringConnectionResponse = DeleteVPCPeeringConnectionResponse'
  { _dvpcrsResponseStatus ::
      Int
  }
  deriving (Eq, Read, Show, Data, Typeable, Generic)

-- | Creates a value of 'DeleteVPCPeeringConnectionResponse' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'dvpcrsResponseStatus' - -- | The response status code.
deleteVPCPeeringConnectionResponse ::
  -- | 'dvpcrsResponseStatus'
  Int ->
  DeleteVPCPeeringConnectionResponse
deleteVPCPeeringConnectionResponse pResponseStatus_ =
  DeleteVPCPeeringConnectionResponse'
    { _dvpcrsResponseStatus =
        pResponseStatus_
    }

-- | -- | The response status code.
dvpcrsResponseStatus :: Lens' DeleteVPCPeeringConnectionResponse Int
dvpcrsResponseStatus = lens _dvpcrsResponseStatus (\s a -> s {_dvpcrsResponseStatus = a})

instance NFData DeleteVPCPeeringConnectionResponse