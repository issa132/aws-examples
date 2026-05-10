# Steps functions allow you to coordinate multiple AWS services into serverless workflows

# What is a state machine?
A state machine is an abstract model which decides how one state moves to another based on a series of conditions. Think of a state machine like a flow chart.

# What is Step Functions?

Coordinate multiple AWS Services into a serverless workflow
A graphical console to visualize the components of your application as a series of steps.
Automatically triggers and tracks each step, and retries when there are errors, so your application executes in order and as expected, every time
logs the state of each step, so when things go wrong, you can diagnose and debug problems quickly

Step Functions has two types of State Machines:
Standard – general purpose
Express – for streaming data

States are configured through Amazon States Language (JSON)
json
"States": {
  "Submit Batch Job": {
    "Type": "Task",
    "Resource": "arn:aws:states:::batch:submitJob.sync",
    "Parameters": {
      "JobName": "BatchJobNotification",
      "JobQueue": "arn:aws:batch:us-east-1:123456789012:j",
      "JobDefinition": "arn:aws:batch:us-east-1:123456789"
    },
    "Next": "Notify Success",
    "Catch": [
      {
        "ErrorEquals": [ "States.ALL" ],
        "Next": "Notify Failure"
      }
    ]
  },
},

# aws.amazon.com/step-functions/use-cases/
# docs.aws.amazon.com/step-functions/latest/dg/batch-job-notification.html

# Step Functions – States
Pass State
Passes its input to its output, without performing work (dummy/mock).
Pass states are useful when constructing and debugging state machines.
Parameters — key-value pairs that will be passed as input
Result — a virtual task to be passed to the next state
ResultPath — where to place the "output" of the virtual task
json{
  "Type": "Pass",
  "Parameters": {
    "ship": "enterprise"
  },
  "Result": {
    "government": "federation"
  },
  "ResultPath": "$.politics",
  "Next": "End"
}
output:
json{
  "ship": "enterprise",
  "politics": {
    "government": "federation"
  }
}


# Step Functions – States
Task - A Supported AWS Service
You pass the ARN as the Resource
Parameters vary per service
Supported Services

Lambda
AWS Batch
DynamoDB
ECS/Fargate
SNS
SQS
SageMaker
EMR

json
{
  "StartAt": "BATCH_JOB",
  "States": {
    "BATCH_JOB": {
      "Type": "Task",
      "Resource": "arn:aws:states:::batch:submitJob.sync",
      "Parameters": {
        "JobDefinition": "preprocessing",
        "JobName": "PreprocessingBatchJob",
        "JobQueue": "SecondaryQueue",
        "Parameters.$": "$.batchjob.parameters",
        "RetryStrategy": {
          "attempts": 5
        }
      },
      "End": true
    }
  }
}


# Task – Activities
enables you to have a task in your state machine where the work is performed by a worker that can be hosted on anywhere eg. EC2, ECS, mobile phones
When Step Functions reaches an activity task state, the workflow waits for an activity worker to poll for a task.


# step functions steps: 
Wait State
delays the state machine from continuing for a specified time.

Succeed State
stops an execution successfully
json
"SuccessState": {
  "Type": "Succeed"
}
The Succeed state is a useful target for Choice state branches that don't do anything but stop the execution.


Fail State
stops the execution of the state machine and marks it as a failure
json
"FailState": {
  "Type": "Fail",
  "Cause": "Overloading.",
  "Error": "WarpCore"
}
Because Fail states always exit the state machine, they have no Next field and don't require an End field.

# Step Functions – States
Parallel States
can be used to create parallel branches of execution in your state machine.
The state machine does not move forward until both states complete.
json
{
  "Comment": "Parallel Example.",
  "StartAt": "LookupCustomerInfo",
  "States": {
    "LookupCustomerInfo": {
      "Type": "Parallel",
      "End": true,
      "Branches": [
        {
          "StartAt": "LookupAddress",
          "States": {
            "LookupAddress": { "Type": "Task",
              "Resource": "arn:aws:lambda:us-east-1:123456789012:function:AddressFinder", "End": true }
          }
        },
        {
          "StartAt": "LookupPhone",
          "States": {
            "LookupPhone": { "Type": "Task",
              "Resource": "arn:aws:lambda:us-east-1:123456789012:function:PhoneFinder", "End": true }
          }
        }
      ]
    }
  }
}

# docs.aws.amazon.com/step-functions/latest/dg/amazon-states-language-map-state.html

# Step Functions – Inputs and Outputs
Step Functions will receive JSON event data as input and pass JSON as output.
json
"input": {
  "version": "0",
  "id": "6fcd98ef-628f-a9e4-4d7f-778217e574...",
  "detail-type": "Object Created",
  "source": "aws.s3",
  "account": "982383527471",
  "time": "2024-05-03T16:58:58Z",
  "region": "us-east-1",
  ...
}
You can manipulate this JSON payload using the following:

InputPath — select a portion of the state input
Parameters — create a collection of key-value pairs that are passed as input.
ResultsSelector — manipulate a state's result before ResultPath is applied
ResultPath — determines what should be outputted, the input, task output or a combination
OutputPath — select a portion of the state output to pass to the next state.


# JSONPath is a query language for JSON, similar to XPath for XML
json
"input": {
  "version": "0",
  "id": "6fcd98ef-628f-a9e4-4d7f-778217e5744a",
  "detail-type": "Object Created",
  "source": "aws.s3",
  "account": "982383527471",
  "time": "2024-05-03T16:58:58Z",
  "region": "us-east-1",
  "resources": [
    "arn:aws:s3:::sf-star-trek-131241"
  ],
  "detail": {
    "version": "0",
    "bucket": {
      "name": "sf-star-trek-131241"
    },
    "object": {
      "key": "inputs/picard.jpg",
      "size": 4879,
      "etag": "98b35d1022f5051b4ec2d8520309d1ff",
      "sequencer": "00663517D2E67AB2A0"
    },
    // ...
  }
}

Expression begin with a $ which represent the root object
Children can be selected using dot notation
Children can be selected using bracket notation

javascript$.input.detail.bucket.name // dot notation
$['input']['detail']['object']['key'] // bracket notation
JSONPath evaluator can be used to help test your jsonpath syntax against a json file → https://jsonpath.com/


// The root object
$

// Dot Notation and Square Notation
$.input.detail['object']['key']

// All 'object' elements at any depth
$..object

// All children of the 'input' object
$.input.*

// First element of 'resources' array
$..resources[0]

// All elements of 'resources' array
$..resources[*]

// All elements where 'size' is greater than 1000
$..[?(@.size > 1000)]

// All elements that have both 'etag' and 'size' properties
$..[?(@.etag && @.size)]

# InputPath allows us to select what we plan to pass to our current step
json
"States": {
  "CurrentStep": {
    "Type": "Pass",
    "InputPath": "$.input.detail.bucket",
    "Next": "NextStep"
  },
}

Input:
json
{
  "input": {
    "version": "0",
    "id": "6fcd98ef-628f-a9e4-4d7f-778217e5744a",
    "detail-type": "Object Created",
    "source": "aws.s3",
    "account": "982383527471",
    "time": "2024-05-03T16:58:58Z",
    "region": "us-east-1",
    "resources": [
      "arn:aws:s3:::sf-star-trek-131241"
    ],
    "detail": {
      "version": "0",
      "bucket": {
        "name": "sf-star-trek-131241"
      },
      "object": {
        "key": "inputs/picard.jpg",
        "size": 4879,
        "etag": "98b35d1022f5051b4ec2d8520309d1ff",
        "sequencer": "00663517D2E67AB2A0"
      },
      //...
    }
  }
}

Output:
json
{ "name": "sf-star-trek-131241" }



# Parameters allows to construct key value pairs. When you want to use JSONPATH for parameters you need to add ".$" to the key name
json
"States": {
  "CurrentStep": {
    "Type": "Pass",
    "Parameters": {
      "bucket.$": "$.input.detail.bucket.name",
      "object_key.$": "$.input.detail.object.key",
      "author": "Andrew"
    },
    "Next": "NextStep"
  },
}
Tasks that call AWS resources may expect specific Parameters.
json
"LambdaState": {
  "Type": "Task",
  "Resource": "arn:aws:states:::lambda:invoke",
  "OutputPath": "$.Payload",
  "Parameters": {
    "Payload.$": "$",
    "FunctionName": "arn:aws:lambda:us-east-1:function:HelloWorld:$LATEST"
  },
  "Next": "NextState"
}


# ResultsSelector lets you create a collection of key value pairs, where the values are static or selected from the state's result.
(Only works for Map, Parallel or Task State)

json
{
  "Comment": "A Step Function state machine that processes data from an S3 event using EC2.",
  "StartAt": "Process Data",
  "States": {
    "Process Data": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:region:account-id:function:function-name",
      "Parameters": {
        "bucket.$": "$.detail.bucket.name",
        "key.$": "$.detail.object.key"
      },
      "ResultPath": "$.processedData",
      "Next": "Run EC2 Task"
    },
    "Run EC2 Task": {
      "Type": "Task",
      "Resource": "arn:aws:states:::elasticmapreduce:addStep.sync",
      "Parameters": {
        "ClusterId": "YourClusterID",
        "Step": {
          "Name": "Process S3 Data on EC2",
          "ActionOnFailure": "CONTINUE",
          "HadoopJarStep": {
            "Properties": [],
            "Jar": "command-runner.jar",
            "Args.$": "States.Array('aws', 's3', 'cp', $.processedData.S3Uri, '/mnt/tmp')"
          }
        }
      },
      "ResultSelector": {
        "InstanceId.$": "$.processedData.InstanceId",
        "OutputLocation.$": "$.processedData.S3Uri"
      },
      "End": true
    }
  }
}
 
# ResultPath lets you decide to:

Use only the output from a task
Use the input as the output
Use the output and add or have it replace an existing key in the input and have that as the output

json// the output will be whatever is return for the task
"ResultPath": "$"

// the output will be the input
"ResultPath": null

// The output from the task will replace a key mydata or create a new key mydata on the input data
"ResultPath": "$.mydata"

OutputPath enables you to select a portion of the state output to pass to the next state.


#  

```sh
 
```