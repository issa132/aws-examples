Introduction to SNS
Simple Notification Service (SNS) is a highly available, durable, secure, fully managed pub/sub messaging service that enables you to decouple microservices, distributed systems, and serverless applications.

Publishers: Who will send messages
SNS Topic : Logical access point for communication
Subscriptions: Who will receive messages

SNS – Destinations
Destinations are the subscribers who can receive messages.
Application-to-Application (A2A)
supports subscribers from AWS Services of web-applications

Data Firehose
Lambda Functions
SQS Queue
HTTP/S endpoint
AWS Event Fork Pipelines

Application-to-Person (A2P)
Supports subscribers from human-entities:

Mobile applications
Mobile phone numbers (SMS aka text messaging)
Email Address

SNS – Topics

Topics allow you to group multiple subscriptions together.
A topic is able to deliver to multiple protocols at once eg. email, text message, http/s
When topics deliver messages to subscribers, it will automatically format your message according to the subscriber's chosen protocol
You can encrypt Topics via KMS

Publishers don't care about the subscribers' protocol
Subscribers listen for incoming messages


shaws sns create-topic --name my-topic
aws sns create-topic --name my-topic.fifo --attributes FifoTopic=true

# SNS – Publishing Large Messages
To publish large messages to SNS you can use the the libraries:

Amazon SNS Extended Client Library for Java/Python

https://github.com/awslabs/amazon-sns-python-extended-client-lib

These libraries are useful for messages that are larger than the current maximum of 256 KB, with a maximum of 2 GB.

# SNS – Message Attributes
SNS supports delivery of message attributes, which let you provide structured metadata items about the message
The supported data types for attributes:

String
String.Array
Number
Binary

shaws sns publish \
--topic-arn "arn:aws:sns:region:account-id:topic-name" \
--message "Notification with various data types for attributes" \
--message-attributes message-attributes.json

{"OrderNumber": {
      "DataType": "number",
      "NumberValue": 4152141,
   }
...}

BatchPublish action can publish upto 10 messages at a time
Sending messages in batches can help you reduce the SNS costs by a factor of 10

# SNS – Message Structure
If you want to send different messages to different kinds of subscribers set message structure to json and supply a json file as the message
shaws sns publish --topic-arn "arn:aws:sns:region:account-id:topic-name" \
--message-structure json \
--message file://message.json
json{
  "default": "Default message",
  "email": "Email message",
  "sms": "SMS message",
  "sqs": "SQS message",
  "http": "HTTP message",
  "https": "HTTPS message",
  "application": "Application message"
}

# SNS – Subscriptions
To receive messages from a topic, you need to create a Subscription.
A Subscription can only subscribe to one protocol and one topic.
The following protocols:

HTTP and HTTPs create webhooks to your web application
Email good for internal email notifications (only supports plain text)
Email-JSON sends you JSON via email
Amazon SQS place SNS message into SQS queue
AWS Lambda triggers a lambda function
SMS sends a text message
Platform application endpoints Mobile Push

docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-sns-topic.html
docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-property-function-sns.html
docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-resource-function.html#sam-resource-function--examples

# chmod u+x bin/*
# ./bin/build
# ./bin/deploy
# docs.aws.amazon.com/cli/latest/reference/sns/publish.html#examples

# SNS – Filter Policy
SNS Filter Policy allows you to filter a subset a messages only to be delivery.
FilterPolicyScope

MessageAttributes – filter based on message attributes
MessageBody — filter base on message body

Filtering Options

AND logic
OR logic
OR operator
Key matching
Numeric value exact matching
Numeric value anything-but matching
Numeric value range matching
String value exact matching
String value anything-but matching

For MessageBody you'd set --attribute-value MessageBody
bashaws sns set-subscription-attributes \
--subscription-arn ... \
--attribute-name FilterPolicy \
--attribute-value file://policy.json
json{
  "store": ["example_corp"],
  "event": [{"anything-but": "order_cancelled"}],
  "customer_interests": [
    "rugby",
    "football",
    "baseball"
  ],
  "price_usd": [{"numeric": [">=", 100]}]
}

# SNS – Message Data Protection
Message data protection safeguards the data that's published to your Amazon SNS topics by using data protection policies to audit, mask, redact, or block the sensitive information that moves between applications or AWS services
Scans for:

Personally identifiable information (PII)
Protected health information (PHI)
via data identifiers

You can choose to use predefined data identifiers:

Name
Addresses
Credit card numbers

You can create your own data identifiers
Supports the following actions:

Audit — Audit upto 99% of data published than send findings to CloudWatch, S3 or Data Firehose
De-identify — mask or redact data
Deny — Block data from being sent


Message data protection can can help to reduce financial, legal, and regulatory risks by complying with privacy regulations such as HIPAA, GDPR, PCI, and FedRAMP.

Message data protection is only supported for standard SNS Topics

aws sns put-data-protection-policy \
--resource-arn arn:aws:sns:us-east-1:123456789012:mytopic \
--data-protection-policy file://policy.json

Example data protection policy that will mask credit card numbers with the pound symbol

{
  "Name": "__example_data_protection_policy",
  "Description": "Example data protection policy",
  "Version": "2021-06-01",
  "Statement": [
    {
      "DataDirection": "Inbound",
      "Principal": [
        "arn:aws:iam::123456789012:user/ExampleUser"
      ],
      "DataIdentifier": [
        "arn:aws:dataprotection::aws:data-identifier/CreditCardNumber"
      ],
      "Operation": {
        "Deidentify": {
          "MaskConfig": {
            "MaskWithCharacter": "#"
          }
        }
      }
    }
  ]
}

# Raw Message Delivery avoid having Amazon Data Firehose, Amazon SQS, and HTTP/S endpoints process the JSON formatting of messages.
aws sns set-subscription-attributes \
--subscription-arn ... \
--attribute-name RawMessageDelivery \
--attribute-value true

Data Firehose and SQS: metadata is stripped from the published message and the message is sent as is.
HTTP/S Endpoint: HTTP header x-amz-sns-rawdelivery with its value set to true, indicating the message should not be formatted

# SNS – Delivery Policy
SNS Delivery Policy defined how SNS retries the delivery of messages when server-side errors occur. Each delivery protocol has its own delivery policy.

When the delivery policy is exhausted, SNS stops retrying the delivery and discards the message unless a dead-letter queue is attached to the subscription.
These data policies cannot be changed with the exception of HTTP/S

# Setting your own delivery policy for HTTP/s endpoint
aws sns set-subscription-attributes \
--subscription-arn ... \
--attribute-name DeliveryPolicy \
--attribute-value file://retry-policy.json

There are four options for backup function

arithmetic
exponential
geometric
linear

{
  "healthyRetryPolicy": {
    "minDelayTarget": 1,
    "maxDelayTarget": 60,
    "numRetries": 50,
    "numNoDelayRetries": 3,
    "numMinDelayRetries": 2,
    "numMaxDelayRetries": 35,
    "backoffFunction": "exponential"
  },
  "throttlePolicy": {
    "maxReceivesPerSecond": 10
  },
  "requestPolicy": {
    "headerContentType": "application/json"
  }
}

# SNS – Dead Letter Queue
SNS Dead Letter Queue (DLQ) will send failed message attempts to an SQS queue.
Topic and Queue type need to match
Standard SNS Topic  →  Standard SQS Queue
FIFO SNS Topic      →  FIFO SQS Queue
Configure a SNS topic to send to a a DQL via the AWS CLI
aws sns set-subscription-attributes \
--subscription-arn ... \
--attribute-name RedrivePolicy \
--attribute-value deadLetterTargetArn=<SQS ARN>

A queue policy will need to be configured to allow SNS to send events to the SQS queue

# Application As Subscriber
Send push notification messages directly to apps on mobile devices.

Push notification messages sent to a mobile endpoint can appear in the mobile app as message alerts, badge updates, or even sound alerts.

