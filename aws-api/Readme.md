## What is an Application Programming Interface (API)?
# An API is software that allows two applications/services to talk to each other. The most common type of API is via HTTP/S requests.
# AWS API is an HTTP API and you can interact by sending HTTPS requests, using an application interacting with APIs like Postman.

# Rarely do users directly send HTTP requests directly to the AWS API. Its much easier to interact with the API via a variety of Developer Tools. Focus on you skill on cli and sdk tools!!! 

# What is a CLI?
# A Command Line Interface (CLI) processes commands to a computer program in the form of lines of text. Operating systems implement a command-line interface in a shell.
# What is a Terminal?
# A terminal is a text only interface (input/output environment)
# What is a Console?
# A console is a physical computer to physically input information into a terminal

# What is a Shell?
# A shell is the command line program that users interact with to input commands. Popular shell programs: Bash, Zsh, PowerShell

# AWS Command Line Interface (CLI) allows users to programmatically interact with the AWS API via entering single or multi-line commands into a shell or terminal
# AWS CLI is a python executable program

# Access Keys is a key and secret required to have programmatic access to AWS resources when interacting with the AWS API outside of the AWS Management Console

# Access Keys are to be store in ~/.aws/credentials and follow a TOML file format
# You can store multiple access keys by giving the profile names.
# You can use the aws configure CLI command to populate the credential file.
# The AWS SDK and CLI will automatically

# When working with APIs you need to plan for possible network failure by trying again.
# It is industry wide recommended for APIs to use an exponential backoff before trying again.
# Try again in 1 second
# Try again in 2 seconds
# Try again in 4 seconds

# Smithy is an open-source interface definition language (IDL) created by AWS to define and build services and SDKs.
# It's used to:
# Define APIs — describe the shape of requests, responses, and operations
# Generate SDKs — automatically generate client code in multiple languages (Python, Java, JavaScript, etc.)
# Generate documentation — auto-generate API docs from the model
# Validate APIs — catch errors in API design early

# STS is a web service that enables you to request temporary, limited-privilege credentials for IAM users or federated users


