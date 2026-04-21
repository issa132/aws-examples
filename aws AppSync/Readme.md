AWS AppSync
AppSync is a fully managed GraphQL service.
Resolvers — attached to specific fields within your types in your schema. Used to implement the state-changing operations for your query, mutation, and subscription field operations.
Data Model
json{
  "data": {
    // resolves to...
    "project": {
      "id": 1,
      "name": "My project"
    },
    // resolves to...
    "tasks": [{
      "id": 1,
      "name": "My todo"
    }]
  }
}

Resolver (Project) → Data Source (DynamoDB)
Resolver (Task) → Data Source (Lambda)

Data Sources — Where data is being pulled from

API Types:

GraphQL APIs — single API from multiple data sources
Merged APIs — a collection of Graph APIs that act as one API

Useful if you have multiple teams that manage their own API but you want to treat all the APIs a single API



Data Sources:

DynamoDB Table
Amazon OpenSearch
AWS Lambda Function
HTTP Endpoint
Amazon EventBridge
Relational Database (RDS HTTP Endpoint)

Caching options:

None — no caching, resolvers will always fetch from data sources
Full request caching — Cache all requests
Per-resolver caching — specific operation or field defined in a resolver will return responses from the cache

Caching required you to provision an on-demand instance. Its not serverless.
Authorization Types:

API Key
AWS IAM
Amazon Cognito User Pools
AppSync supports custom domains
AppSync has a query editor built into the UI

Resolver Runtimes:

APPSYNC_JS — Javascript
VTL — Velocity Template Language

# ca-central-1.console.aws.amazon.com/appsync/home?region=ca-central-1#/ewpyqqupgzaarl5a7xqk4myafe/v1/home
npm init -y
github.com/amazon-archives/aws-mobile-appsync-events-starter-react

npm install ---save graphql-tag

# docs.amplify.aws/react/build-a-backend/graphqlapi/
# docs.amplify.aws/react/build-a-backend/graphqlapi/query-data/

