Introduction to AWS Lambda
AWS Lambda is a serverless Function as Service that lets you run code without provisioning or managing servers.
Lambda executes your code only when needed and scales automatically to a few to a 1000 lambda functions concurrently in seconds.
You pay only for the compute time you consume. There is *no charge when your code is not running.
AWS Lambda Supports multiple runtimes:

Ruby
Python
Java
Go
Powershell
NodeJs
C#
Rust

# AWS Lambda – Use Cases
Lambda is commonly used to glue different services together, so the use cases are endless.

Processing Thumbnails
A web service allows users to upload their profile photos. They are stored in an S3 bucket. We can set up an Event Trigger that will invoke a Lambda, which will process the Profile Photo into a Thumbnail and store it back in the bucket.
Image → PUT → S3 Bucket → Trigger Lambda → Process Image Into Thumbnail → Store Thumbnail → S3 Bucket

Contact Email Form
A company has a contact email form that submits form data via API Gateway Endpoint. That endpoint triggers a lambda which validates the form data and, if valid, will save the submission in DynamoDB and send an email notification via SNS to the company.
Form → POST → API Gateway → Trigger Lambda → Process Email Contact Form → Record Submission as Item in DynamoDB table / Notify via Email About Submission

# AWS Lambda – Destinations
AWS Lambda can be invoked in two ways:

Sync Invocations — data that waits for a response eg. HTTP response
Async Invocations — data that immediately returns to async AWS services

Destination is for invoking Async invocation
Destination:

SNS Topic
SQS Queue
Lambda Function
EventBridge Bus

# AWS Lambda – Memory and Timeout
Time settings:

Default: 3 seconds
Min: 1 second
Max: 15 minutes

Storage settings:

Default: 512 MB
Min: 512 MB
Max: 10,240 MB (~10 GB)

Memory settings: (Increments of 1 MB)

Default: 128 MB
Min: 128 MB
Max: 10,240 MB (~10 GB)

# Lambda – Function Versions
When you reference a Lambda use its ARN. A Lambda has two initial versions:
Qualified ARN — The function ARN with the version suffix.
arn:aws:lambda:aws-region:acct-id:function:helloworld:$LATEST
Unqualified ARN — The function ARN without the version suffix.
arn:aws:lambda:aws-region:acct-id:function:helloworld
You cannot create Aliases with Unqualified ARN
Unqualified ARNs points to the Latest.

# Lambda – Aliases
Aliases allow you to give specific versions a friendlier name when accessing the lambda programmatically.

# Lambda – Layers
Pull in additional code and content in the form of layers.
A layer is a ZIP archive that contains libraries, a custom runtime, or other dependencies.
You can use libraries in your function without needing to include them in your deployment package.
You can have up to 🖐 5 layers attached to a function.
All layers can't exceed the unzipped deployment package size limit of 250 MB.

# Lambda – Instruction Set
There are two available Instruction architectures available for Lambda:

arm64 – 64-bit ARM architecture, for the AWS Graviton2 processor.
x86_64 – 64-bit x86 architecture, for x86-based processors.

An Instruction Set are a set of opcode that represent operations the CPU can perform.

Load (LDA) — 01x1000
Store (STA) — 02-1001
Add (ADD) — 03x1002
Jump (JMP) — 04x1003
Subtract (SUB) — 05x1004

Arm64 has a smaller instruction set therefore programs built against arm are more efficient and as a result are more cost effective.
For a program to run a specific architecture the language has to turn into a machine language such (assembly code) which in turn is calling opcodes.

# When possible use Arm64 since it's most proficient.
All Amazon Linux 2 (AL2) runtimes support both x86_64 and ARM CPU architectures.

# Lambda – Runtimes
Lambda Runtime is a preconfigured environment to run specific programming languages.
Runtimes are useful since it doesn't require you to configure a container or OS configuration.
Runtimes are fully managed and are security-hardened by AWS.
Lambda Runtimes are released as stable programming languages are released.
Older Runtimes are deprecated, which will force you to upgrade your Lambdas and their code to run on more recent runtime versions.
bash
aws lambda create-function \
--function-name MyRubyFunction \
--handler lambda_function.lambda_handler \
--runtime ruby3.2 \
--role arn:aws:iam::123456789012:role/execution_role \
--zip-file fileb://function.zip
A runtime will specify a:

Named Version: eg. Node.js 20
Identifier: eg. nodejs20.x
Operation System: eg. Amazon Linux 2023

The identifier is used to tell what runtime to use.
Code is delivered as a ZIP archive when using Lambda runtimes.

# Lambda – OS-Only Runtimes
OS-Only Runtimes is when there is not preinstalled programming language and language specific libraries installed when you want to compile your languages or programs to be used.
There are 3 cases when to use OS-Only Runtimes:
1. Native ahead-of-time (AOT) compilation
Languages such as Go, Rust, and C++, .NET Native AOT, Java GraalVM Native compile natively to an executable binary, which doesn't require a dedicated language runtime.

You must include a runtime interface client in your binary.
You must compile your binary for a Linux environment for the same instruction set architecture.

2. Third-party runtimes

Runtimes such as Bref for PHP
Swift AWS Lambda Runtime for Swift.

3. Custom runtimes
Build your own runtime for a language or language version that Lambda doesn't provide a managed runtime.

# Lambda – Deployment Packages Container
No runtime is specified. Instead you supply the Dockerfile or container image url eg. ECR
yaml
AWSTemplateFormatVersion: '2010-09-09'
Transform: AWS::Serverless-2016-10-31
Resources:
  InlineLambda:
    Type: AWS::Serverless::Function
    Metadata:
      DockerContext: "../"
      Dockerfile: Dockerfile
    Properties:
      PackageType: Image

# docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-resource-function.html
# docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-resource-function.html#sam-resource-function--examples
# docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-specification-template-anatomy.html
# github.com/teacherseat/evaluators/tree/main/python
# github.com/teacherseat/evaluators/blob/main/python/template.yaml
# docs.aws.amazon.com/lambda/latest/dg/lambda-python.html


# Install SAM CLI

```sh
./bin/aws_sam_cli_install.sh
```

# docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-using-build.html

# Install CFN Lint

```sh
brew install cfn-lint
```

## Build and Deploy

```sh
sam build
sam deploy
```





