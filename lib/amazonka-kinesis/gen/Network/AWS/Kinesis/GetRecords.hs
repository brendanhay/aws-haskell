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
-- Module      : Network.AWS.Kinesis.GetRecords
-- Copyright   : (c) 2013-2020 Brendan Hay
-- License     : Mozilla Public License, v. 2.0.
-- Maintainer  : Brendan Hay <brendan.g.hay+amazonka@gmail.com>
-- Stability   : auto-generated
-- Portability : non-portable (GHC extensions)
--
-- Gets data records from a Kinesis data stream's shard.
--
--
-- Specify a shard iterator using the @ShardIterator@ parameter. The shard iterator specifies the position in the shard from which you want to start reading data records sequentially. If there are no records available in the portion of the shard that the iterator points to, 'GetRecords' returns an empty list. It might take multiple calls to get to a portion of the shard that contains records.
--
-- You can scale by provisioning multiple shards per stream while considering service limits (for more information, see <https://docs.aws.amazon.com/kinesis/latest/dev/service-sizes-and-limits.html Amazon Kinesis Data Streams Limits> in the /Amazon Kinesis Data Streams Developer Guide/ ). Your application should have one thread per shard, each reading continuously from its stream. To read from a stream continually, call 'GetRecords' in a loop. Use 'GetShardIterator' to get the shard iterator to specify in the first 'GetRecords' call. 'GetRecords' returns a new shard iterator in @NextShardIterator@ . Specify the shard iterator returned in @NextShardIterator@ in subsequent calls to 'GetRecords' . If the shard has been closed, the shard iterator can't return more data and 'GetRecords' returns @null@ in @NextShardIterator@ . You can terminate the loop when the shard is closed, or when the shard iterator reaches the record with the sequence number or other attribute that marks it as the last record to process.
--
-- Each data record can be up to 1 MiB in size, and each shard can read up to 2 MiB per second. You can ensure that your calls don't exceed the maximum supported size or throughput by using the @Limit@ parameter to specify the maximum number of records that 'GetRecords' can return. Consider your average record size when determining this limit. The maximum number of records that can be returned per call is 10,000.
--
-- The size of the data returned by 'GetRecords' varies depending on the utilization of the shard. The maximum size of data that 'GetRecords' can return is 10 MiB. If a call returns this amount of data, subsequent calls made within the next 5 seconds throw @ProvisionedThroughputExceededException@ . If there is insufficient provisioned throughput on the stream, subsequent calls made within the next 1 second throw @ProvisionedThroughputExceededException@ . 'GetRecords' doesn't return any data when it throws an exception. For this reason, we recommend that you wait 1 second between calls to 'GetRecords' . However, it's possible that the application will get exceptions for longer than 1 second.
--
-- To detect whether the application is falling behind in processing, you can use the @MillisBehindLatest@ response attribute. You can also monitor the stream using CloudWatch metrics and other mechanisms (see <https://docs.aws.amazon.com/kinesis/latest/dev/monitoring.html Monitoring> in the /Amazon Kinesis Data Streams Developer Guide/ ).
--
-- Each Amazon Kinesis record includes a value, @ApproximateArrivalTimestamp@ , that is set when a stream successfully receives and stores a record. This is commonly referred to as a server-side time stamp, whereas a client-side time stamp is set when a data producer creates or sends the record to a stream (a data producer is any data source putting data records into a stream, for example with 'PutRecords' ). The time stamp has millisecond precision. There are no guarantees about the time stamp accuracy, or that the time stamp is always increasing. For example, records in a shard or across a stream might have time stamps that are out of order.
--
-- This operation has a limit of five transactions per second per shard.
module Network.AWS.Kinesis.GetRecords
  ( -- * Creating a Request
    getRecords,
    GetRecords,

    -- * Request Lenses
    grLimit,
    grShardIterator,

    -- * Destructuring the Response
    getRecordsResponse,
    GetRecordsResponse,

    -- * Response Lenses
    grrsNextShardIterator,
    grrsMillisBehindLatest,
    grrsChildShards,
    grrsResponseStatus,
    grrsRecords,
  )
where

import Network.AWS.Kinesis.Types
import Network.AWS.Lens
import Network.AWS.Prelude
import Network.AWS.Request
import Network.AWS.Response

-- | Represents the input for 'GetRecords' .
--
--
--
-- /See:/ 'getRecords' smart constructor.
data GetRecords = GetRecords'
  { _grLimit :: !(Maybe Nat),
    _grShardIterator :: !Text
  }
  deriving (Eq, Read, Show, Data, Typeable, Generic)

-- | Creates a value of 'GetRecords' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'grLimit' - The maximum number of records to return. Specify a value of up to 10,000. If you specify a value that is greater than 10,000, 'GetRecords' throws @InvalidArgumentException@ . The default value is 10,000.
--
-- * 'grShardIterator' - The position in the shard from which you want to start sequentially reading data records. A shard iterator specifies this position using the sequence number of a data record in the shard.
getRecords ::
  -- | 'grShardIterator'
  Text ->
  GetRecords
getRecords pShardIterator_ =
  GetRecords'
    { _grLimit = Nothing,
      _grShardIterator = pShardIterator_
    }

-- | The maximum number of records to return. Specify a value of up to 10,000. If you specify a value that is greater than 10,000, 'GetRecords' throws @InvalidArgumentException@ . The default value is 10,000.
grLimit :: Lens' GetRecords (Maybe Natural)
grLimit = lens _grLimit (\s a -> s {_grLimit = a}) . mapping _Nat

-- | The position in the shard from which you want to start sequentially reading data records. A shard iterator specifies this position using the sequence number of a data record in the shard.
grShardIterator :: Lens' GetRecords Text
grShardIterator = lens _grShardIterator (\s a -> s {_grShardIterator = a})

instance AWSRequest GetRecords where
  type Rs GetRecords = GetRecordsResponse
  request = postJSON kinesis
  response =
    receiveJSON
      ( \s h x ->
          GetRecordsResponse'
            <$> (x .?> "NextShardIterator")
            <*> (x .?> "MillisBehindLatest")
            <*> (x .?> "ChildShards" .!@ mempty)
            <*> (pure (fromEnum s))
            <*> (x .?> "Records" .!@ mempty)
      )

instance Hashable GetRecords

instance NFData GetRecords

instance ToHeaders GetRecords where
  toHeaders =
    const
      ( mconcat
          [ "X-Amz-Target" =# ("Kinesis_20131202.GetRecords" :: ByteString),
            "Content-Type" =# ("application/x-amz-json-1.1" :: ByteString)
          ]
      )

instance ToJSON GetRecords where
  toJSON GetRecords' {..} =
    object
      ( catMaybes
          [ ("Limit" .=) <$> _grLimit,
            Just ("ShardIterator" .= _grShardIterator)
          ]
      )

instance ToPath GetRecords where
  toPath = const "/"

instance ToQuery GetRecords where
  toQuery = const mempty

-- | Represents the output for 'GetRecords' .
--
--
--
-- /See:/ 'getRecordsResponse' smart constructor.
data GetRecordsResponse = GetRecordsResponse'
  { _grrsNextShardIterator ::
      !(Maybe Text),
    _grrsMillisBehindLatest :: !(Maybe Nat),
    _grrsChildShards :: !(Maybe [ChildShard]),
    _grrsResponseStatus :: !Int,
    _grrsRecords :: ![Record]
  }
  deriving (Eq, Read, Show, Data, Typeable, Generic)

-- | Creates a value of 'GetRecordsResponse' with the minimum fields required to make a request.
--
-- Use one of the following lenses to modify other fields as desired:
--
-- * 'grrsNextShardIterator' - The next position in the shard from which to start sequentially reading data records. If set to @null@ , the shard has been closed and the requested iterator does not return any more data.
--
-- * 'grrsMillisBehindLatest' - The number of milliseconds the 'GetRecords' response is from the tip of the stream, indicating how far behind current time the consumer is. A value of zero indicates that record processing is caught up, and there are no new records to process at this moment.
--
-- * 'grrsChildShards' - Undocumented member.
--
-- * 'grrsResponseStatus' - -- | The response status code.
--
-- * 'grrsRecords' - The data records retrieved from the shard.
getRecordsResponse ::
  -- | 'grrsResponseStatus'
  Int ->
  GetRecordsResponse
getRecordsResponse pResponseStatus_ =
  GetRecordsResponse'
    { _grrsNextShardIterator = Nothing,
      _grrsMillisBehindLatest = Nothing,
      _grrsChildShards = Nothing,
      _grrsResponseStatus = pResponseStatus_,
      _grrsRecords = mempty
    }

-- | The next position in the shard from which to start sequentially reading data records. If set to @null@ , the shard has been closed and the requested iterator does not return any more data.
grrsNextShardIterator :: Lens' GetRecordsResponse (Maybe Text)
grrsNextShardIterator = lens _grrsNextShardIterator (\s a -> s {_grrsNextShardIterator = a})

-- | The number of milliseconds the 'GetRecords' response is from the tip of the stream, indicating how far behind current time the consumer is. A value of zero indicates that record processing is caught up, and there are no new records to process at this moment.
grrsMillisBehindLatest :: Lens' GetRecordsResponse (Maybe Natural)
grrsMillisBehindLatest = lens _grrsMillisBehindLatest (\s a -> s {_grrsMillisBehindLatest = a}) . mapping _Nat

-- | Undocumented member.
grrsChildShards :: Lens' GetRecordsResponse [ChildShard]
grrsChildShards = lens _grrsChildShards (\s a -> s {_grrsChildShards = a}) . _Default . _Coerce

-- | -- | The response status code.
grrsResponseStatus :: Lens' GetRecordsResponse Int
grrsResponseStatus = lens _grrsResponseStatus (\s a -> s {_grrsResponseStatus = a})

-- | The data records retrieved from the shard.
grrsRecords :: Lens' GetRecordsResponse [Record]
grrsRecords = lens _grrsRecords (\s a -> s {_grrsRecords = a}) . _Coerce

instance NFData GetRecordsResponse