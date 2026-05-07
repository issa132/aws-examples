# The CloudWatch Agent can be installed using AWS Systems Manager (SSM) Run Command onto the target EC2 instance.
in order to install cloudwatch agent, you search for AWS-configureAwsPackage 

# You must attach the CloudWatchAgentServerRole IAM role to the EC2 instance to be able to run the agent on the instance.

# Amazon EventBridge – The Anatomy of an Event
The top level fields listed here will always appear in every single event.
The contents of fields appearing under detail will vary based on what AWS Cloud service emits the event.
version By default, this is set to 0 (zero) in all events.
id A unique value is generated for every event.
detail-type Identifies fields and values that appear in the detail field.
source Identifies the service that sourced the event.
account 12-digit number identifying AWS account.
time the event timestamp.
region AWS region where the event originated.
resources JSON array contains ARNs that identify resources that are involved in the event.
detail JSON object containing data provided by the Cloud Service. Can contain 50 fields nested several levels deep.
json{
  "version": "0",
  "id": "6a7e8feb-b391-4ef7-e9f1-bf3703467718",
  "detail-type": "EC2 Instance State-change Notification",
  "source": "aws.ec2",
  "account": "121212121212",
  "time": "2020-05-22T14:22:48Z",
  "region": "us-east-1",
  "resources": [
    "arn:aws:ec2:us-east-1:123456789012:instance/i-1234567890abcdef0"
  ],
  "detail": {
    "instance-id": "i-1234567890abcdef0",
    "state": "terminated"
  }
}

# Amazon EventBridge – Scheduled Expressions
You can create EventBridge Rules that trigger on a schedule. You can think of it as Serverless Cron Jobs

All scheduled events use UTC time zone
the minimum precision for schedules is 1 minute.

EventBridge supports cron expressions and rate expressions

# Amazon EventBridge – CloudTrail Events
Not all AWS Services emit CloudWatch Events.
For other AWS Services we can use CloudTrail
Turning on CloudTrail allows EventBridge to track changes to AWS Services made by API calls or by AWS users.
The Detail Type of CloudTrail will be called:
"AWS API Call via CloudTrail"
AWS API call events that are larger than 256 KB in size are not supported.

JSON example shown:
json
{
  "detail-type": "AWS API Call via CloudTrail",
  "detail": {
    "eventVersion": "1.03",
    "userIdentity": {
      "type": "Root",
      "principalId": "123456789012",
      "arn": "arn:aws:iam::123456789012:root",
      "accountId": "123456789012",
      "sessionContext": {
        "attributes": {
          "mfaAuthenticated": "false",
          "creationDate": "2020-02-20T01:05:59Z"
        }
      }
    },
    "eventTime": "2020-02-20T01:09:13Z",
    "eventSource": "s3.amazonaws.com",
    "eventName": "CreateBucket",
    "awsRegion": "us-east-1",
    "sourceIPAddress": "100.100.100.100",
    "userAgent": "[S3Console/0.4]",
    "requestParameters": {
      "bucketName": "my-bucket"
    },
    "responseElements": null,
    "requestID": "9D767BCC3B4E7487",
    "eventID": "24ba271e-d595-4e66-a7fd-9c16cbf8abae",
    "eventType": "AwsApiCall"
  }
}

# Amazon EventBridge – Event Patterns
Event Patterns are used to filter what events should be used to pass along to a target.
You can filter events by providing the same fields and values found in the original Events.
Let us say we want to create a rule that only reacts to when an EC2 instance is terminated.
Original Event:
json
{
  "version": "0",
  "id": "6a7e8feb-b491-4cf7-a9f1-bf3703467718",
  "detail-type": "EC2 Instance State-change Notification",
  "source": "aws.ec2",
  "account": "111122223333",
  "time": "2020-12-22T18:43:48Z",
  "region": "us-east-1",
  "resources": [
    "arn:aws:ec2:us-east-1:123456789012:instance/i-1234567890abcdef0"
  ],
  "detail": {
    "instance-id": "i-1234567890abcdef0",
    "state": "terminated"
  }
}
We would just supply the following as the Event Pattern:
json
{
  "source": [ "aws.ec2" ],
  "detail-type": [ "EC2 Instance State-change Notification" ],
  "detail": {
    "state": [ "terminated" ]
  }
}

event patern --> custom patern and paste the last json 

# Prefix Matching
match on the prefix of a value in the event source
json
"region": [ { "prefix": "ca-" } ]

Anything-but Matching
matches anything except what's provided in the rule
json
"state": [ { "anything-but": [ "stopped", "overloaded" ] } ]

Numeric Matching
Matches against numeric operator for "<", ">", "=", "<=", ">="
json
"x-limit": [ { "numeric": [ ">", 0, "<=", 5 ] } ]

IP Address Matching
matching against available for both IPv4 and IPv6 addresses
json
"source-ip": [ { "cidr": "10.0.0.0/24" } ]

# Exists Matching
matching works on the presence or absence of a field in the JSON
json
"c-count": [ { "exists": false } ]

Empty Value Matching
For strings you can use "" to match empty
For other values you can use null
json
"eventVersion": [""]
json
"responseElements": [null]

# Complex Example with Multiple Matching
combine multiple matching rules into a more complex event pattern
json
{
  "time": [ { "prefix": "2017-10-02" } ],
  "detail": {
    "state": [ { "anything-but": "initializing" } ],
    "c-count": [ { "numeric": [ "<", 10 ] } ],
    "x-limit": [ { "anything-but": [ 100, 200, 300 ] } ]
  }
}

# Amazon EventBridge – Rules
You specify up to five Targets for a single rule. Commonly targeted AWS Cloud Services:

Lambda Function
SQS queue
SNS topic
Firehose delivery stream
ECS Task

You may have some additional fields to select the target. Eg.

Lambda Function
Lambda Alias
Lambda Version


You can specify what gets passed along by changing Configure Input. This acts as sort of filter.
Configure input options:

Matched events
Part of the matched event
Constant (JSON text)
Input transformer


Match Events
The entire event pattern text is passed to the target when the rule is triggered. (Just Pass everything.)

# Amazon EventBridge – Configure Input
Match Events — The entire event pattern text is passed to the target when the rule is triggered.

Part of the matched event
Only the part of the event text that you specify is passed to the target.
$.detail

Constant (JSON text)
Send static content instead of the matched event data. (Mocked JSON)
json{ "success": true }

Input Transformer
You can transform the event text to a different format of a string or a JSON object.
You can map fields from the event data to variables. Then you can use those variables in a string or JSON object and that is what gets passed along.
As a string:
json
{
  "instance" : "$.detail.instance",  # mapping to a variable call instance. $ sign is like selecting the base of a json object
  "state" : "$.detail.state"
}
"instance <instance> is in <state>"
As a JSON object:
json
{
  "instance" : "$.detail.instance",
  "state" : "$.detail.state"
}
json
{
  "instance" : <instance>,
  ...
}

# You can't use these as variable names (reserved by AWS):

aws.events.rule-arn
aws.events.rule-name
aws.events.event

# Amazon EventBridge – Schema Registry
EventBridge Schema Registry allows you to create, discover and manage OpenAPI schemas for events on EventBridge.
What is a schema?
A schema is an outline, diagram, or model. Schemas are often used to describe the structure of different types of data.

# Amazon EventBridge – Schema Registry
EventBridge Schema Registry allows you to create, discover and manage OpenAPI schemas for events on EventBridge.
What is a schema?
A schema is an outline, diagram, or model. Schemas are often used to describe the structure of different types of data.

Why would you want a schema of the events in your EventBridge event bus?
So you can see if the structure of the events have changed over time.

This makes it easier for developers to know what data to expect from a type of event so it's easier to integrate into applications.

By installing the AWS Toolkit for VSCode you can easily View Schemas and install Code Bindings.

# A CloudWatch Alarm monitors a CloudWatch Metric based on a defined threshold.

When alarm breaches (goes outside the defined threshold) then it changes state.
Metric Alarm States
  OK — The metric or expression is within the defined threshold
  ALARM — The metric or expression is outside of the defined threshold
  INSUFFICIENT_DATA - The alarm has just started, the metric is not available, Not enough data is available


When it changes state we can define what action it should trigger.

  Notification
  Auto Scaling Group
  EC2 Action

# Composite Alarms are alarms that watch other alarms.
Using composite alarms can help you reduce alarm noise.
Imagine you have two Alarms and you configure them to have no action:

CPU Utilization
NetworkIn

You select both Alarms and create a Composite Alarm 

The only action you can configure for a composite alarm is an SNS Topic

 
Claude a répondu : What is an Event Bus?
What is an Event Bus? An event bus receives events from a source and routes events to a target based on rules

Event
  ↓
[Event Bus]
  ├── Rule → [Event][Event] → Target
  └── Rule → [Event][Event][Event][Event] → Target
EventBridge is a serverless event bus service that is used for application integration by streaming real-time data to your applications.

