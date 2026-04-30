# Introduction to SQS
What is a Messaging System?
Used to provide asynchronous communication and decouple processes via messages / events
From a sender and receiver ( producer and consumer)
What is a Queueing System?
A Queueing system is a messaging system that generally will delete messages once they are consumed.
Simple communication. Not Real-time. Have to pull. Not reactive.
Simple Queueing Service (SQS)
Fully managed queuing service that enables you to decouple and scale microservices, distributed systems, and serverless applications
Use Case: You need to queue up transaction emails to be sent e.g. Signup, Reset Password.

# SQS – Use Case

App publishes messages to the queue
Another app pulls the queue and finds the message, and does something
Another app reports that they completed their task and marks the message for completion
Original app pulls the queue and sees the message is no longer in the queue.

Both apps are using the AWS SDK to push messages and pull the queue.

# SQS – Sending Large Messages
To send large messages to SQS you can use the the libraries:

Amazon SQS Extended Client Library for Java/Python

https://github.com/awslabs/amazon-sqs-python-extended-client-lib
These libraries are useful for messages that are larger than the current maximum of 256 KB, with a maximum of 2 GB.
Both libraries save the actual payload to an S3 bucket, and publish the reference of the stored S3 object to the SNS topic.

import boto3
import sns_extended_client

sns = boto3.client('sns')
sns.large_payload_support = 'bucket-name'

# boto SNS.Topic resource
resource = boto3.resource('sns')
topic = resource.Topic('topic-arn')
platform_endpoint = resource.PlatformEndpoint('endpoint-arn')
platform_endpoint.large_payload_support = 'my-bucket-name'

# If you want to keep it always enabled.
platform_endpoint.always_through_s3 = True

# publish the large message
sns.publish(
  Message="message",
  MessageAttributes={
    "S3Key": {
      "DataType": "String",
      "StringValue": "--S3--Key--",
    },
  },
)


there is standard queue and FIFO queue

you cant convert a standard queue to a fifo queue

# SQS – FIFO Queue
AWS SQS First-In-First-Out (FIFO) guarantees the order of messages when being consumed
→ | 1 | 2 | 3 | 4 | 5 | →

Limited to 300 transactions per second (TPS)
Messages have a unique deduplication ID to ensure there are no duplicate messages in the queue

    Since there are no duplicates FIFO ensures Exactly-once processing


Messages are ordered based on Message Group Id.
To ensure order is preserved each Producer should use their own unique Message Group Id.
To request (poll) messages your Consumer has to specify a Message Group Id
Its possible to read upto 10 messages a time.
SQS FIFO manages data in partitions across multiple AZs, but its all managed for you by AWS.

    Each partition supports 3,000 messages per second with batching
    Or up to 300 messages per second for send, receive, and delete operations

# Sending message to a FIFO queue. Note that you have to provide:

message_group_id
Message_deduplication_id

ruby
require 'aws-sdk-sqs'

sqs_client = Aws::SQS::Client.new(region: 'us-west-2')

queue_url = 'https://sqs.us-west-2.amazonaws.com/123456789012/my-queue.fifo'

message_body = 'Hello, FIFO World!'
message_group_id = 'myMessageGroup1'
message_deduplication_id = 'myMessageDeduplicationId1'

begin
  sqs_client.send_message(
    queue_url: queue_url,
    message_body: message_body,
    message_group_id: message_group_id,
    message_deduplication_id: message_deduplication_id
  )
  puts "Message sent to FIFO queue successfully."
rescue Aws::SQS::Errors::ServiceError => e
  puts "Error sending message to FIFO queue: #{e}"
end

# SQS – FIFO Queue
High Throughput can be enabled on SQS FIFO queue to allows for 3,000 messages per second with batching (10x greater than SQS FIFO queue without High Throughput)
To enable High Throughput you set FifoThroughputLimit=perMessageGroupId
bash
aws sqs set-queue-attributes \
--queue-url "https://sqs.ca-central-1.amazonaws.com/123456789012/my-queue.fifo" \
--attributes \
FifoQueue=true,\
ContentBasedDeduplication=true,\
DeduplicationScope="messageGroup"\
FifoThroughputLimit="perMessageGroupId"

# docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-resource-function.html
# docs.aws.amazon.com/lambda/latest/dg/with-sqs-example-use-app-spec.html

# awscli.amazonaws.com/v2/documentation/api/latest/reference/sqs/index.html
# awscli.amazonaws.com/v2/documentation/api/latest/reference/sqs/send-message.html#examples

# docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-message-metadata.html#sqs-message-attributes
# awscli.amazonaws.com/v2/documentation/api/latest/reference/sqs/receive-message.html#examples
# awscli.amazonaws.com/v2/documentation/api/latest/reference/sqs/get-queue-attributes.html#examples
# awscli.amazonaws.com/v2/documentation/api/latest/reference/sqs/receive-message.html#output

bundle init
bundle install # install the gem 
bundle exec ruby send.rb
resp.messages
resp.messages.first.receipt_handle

# docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/SQS/Client.html#delete_message-instance_method
resp = client.delete_message({
  queue_url: "String", # required
  receipt_handle: "String", # required
})

# github.com/ruby-shoryuken/shoryuken
Il s'agit du lien vers le dépôt GitHub de Shoryuken, une bibliothèque Ruby populaire pour traiter les messages Amazon SQS de manière asynchrone, souvent utilisée comme alternative à Sidekiq mais pour SQS.


