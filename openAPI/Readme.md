OpenAPI

OpenAPI Specification (OAS) defines a standard, language-agnostic interface to RESTful APIs which allows both humans and computers to discover and understand the capabilities of the service without access to source code, documentation, or through network traffic inspection.

Swagger and OpenAPI used to be the same thing but as of OpenAPI V3, Swagger and OpenAPI are two different things

    OpenAPI = Specification
    Swagger = Tools for implementing the specification

OpenAPI can be represented as either JSON or YAML

# What is an API Gateway?What is an API Gateway?
An API Gateway is a program that sits between a single-entry point and multiple backends.
API Gateway allows for throttling (étranglement: technique qui consiste à limiter le nombre de requêtes qu'un client peut envoyer à une API dans un laps de temps donné), logging, routing logic or formatting of the request and response
Amazon API Gateway is a solution for creating secure APIs in your cloud environment at any scale.
Create APIs that act as a front door for applications to access data, business logic, or functionality from back-end services

# There are three types of APIs for API Gateway:

Rest API (API Gateway V1)

    Complete Control over Request and Response
    Most feature-rich
    Higher costs
    Both Private and Public API options
    HTTP API (API Gateway V2)

Low Latency

    Simpler feature set
    Low costs
    Only Public APIs

WebSockets API

    persistent connections for real-time use cases such as chat applications or dashboards

# For both REST and HTTP APIs you can import an Open API 3 file when creating your API.
yaml
openapi: 3.0.0
info:
  version: 1.0.0
  title: Simple API
  description: My API example
paths:
  /hello:
    get:
      summary: Returns a greeting message
      responses:
        '200':
          description: A greeting message
          content:
            application/json:
              schema:
                type: object
                properties:
                  message:
                    type: string
                    example: Hello, world!

yaml
AWSTemplateFormatVersion: '2010-09-09'
Resources:
  MyApi:
    Type: AWS::ApiGateway::RestApi
    Properties:
      Name: SimpleApi
      Body:
        'Fn::Transform':
          Name: 'AWS::Include'
          Parameters:
            Location: !Sub 's3://${BucketName}/openapi.yaml'


# OpenAPI Extensions for AWS

AWS extends the OpenAPI definition so you can define AWS API Gateway specific features in your OpenAPI File.
x-amazon-apigateway-extension

-any-method object
-cors object
-api-key-source property
-auth object
-authorizer object
-authtype property
-binary-media-types property
-documentation object
-endpoint-configuration object
-gateway-responses object
-gateway-responses.gatewayResponse object
-gateway-responses.responseParameters object
-gateway-responses.responseTemplates object
-importexport-version
-tag-value property
-integration object
-integrations object
-integration.requestTemplates object
-integration.requestParameters object
-integration.responses object
-integration.response object
-integration.responseTemplates object
-integration.responseParameters object
-integration.tlsConfig object
-minimum-compression-size
-policy
-request-validator property
-request-validators object
-request-validators.requestValidator object

Here's an example of using the -policy extension To define IAM Policy for specific API paths.
yaml
---
x-amazon-apigateway-policy:
  Version: '2012-10-17'
  Statement:
  - Effect: Allow
    Principal: "*"
    Action: execute-api:Invoke
    Resource:
    - execute-api:/*
  - Effect: Deny
    Principal: "*"
    Action: execute-api:Invoke
    Resource:
    - execute-api:/*
    Condition:
      IpAddress:
        aws:SourceIp: 192.0.2.0/24

Here's an example of using the -cors To define CORS for the API.
yaml
---
x-amazon-apigateway-cors:
  allowOrigins:
  - https://www.example.com
  allowCredentials: true
  exposeHeaders:
  - x-apigateway-header
  - x-amz-date
  - content-type
  maxAge: 3600
  allowMethods:
  - GET
  - OPTIONS
  - POST
  allowHeaders:
  - x-apigateway-header
  - x-amz-date
  - content-type

CORS (Cross-Origin Resource Sharing) est un mécanisme de sécurité des navigateurs web qui contrôle les requêtes HTTP entre deux domaines différents.

# API Gateway REST Components

API — container for multiple resources
Resources — represent an endpoint. Resources are nested within other resources

Methods — are individual methods for a specific endpoint. Methods have allow you to customize Requests and Response
    Method Request
    Integration Request
    Method Response
    Integration Response

Integration
The integration service that will be called

    Lambda function (AWS_Proxy)
    HTTP
    Mock
    AWS Service
    VPC Link

Stage — Versions of your APIStage — Versions of your API
Stages must be deployed to be accessible.

# API Gateway HTTP Components

API — container for multiple routes
Routes — represent an endpoint. routes are nested within other routes

  You choose the method
  You defined your endpoint

Integration
The integration service that will be called

    Lambda function (AWS_PROXY)
    HTTP
    AWS Service (limited to specific services)
        EventBridge, SQS, AppConfig, Kinesis Data Streams, Step Functions
    VPC Link

Stage — Versions of your API
Stages must be deployed to be accessible.
API Gateway has a special stage called $default. 
All changes that you make to your API are autodeployed to that stage.

