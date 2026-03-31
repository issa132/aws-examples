

## create website 1 
## create a buket
##  
```sh
aws s3 mb s3://cb-fun-ab-36252
```

## change block public access
## awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/put-public-access-block.html
```sh
aws s3api put-public-access-block \
--bucket cb-fun-ab-36252 \
--public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=false,RestrictPublicBuckets=false"

```
## Cette commande AWS CLI configure les paramètres de blocage d'accès public pour un bucket S3 nommé "cb-fun-ab-36252" avec les options suivantes :

## BlockPublicAcls=true : Bloque les nouvelles ACL publiques
## IgnorePublicAcls=true : Ignore les ACL publiques existantes
## BlockPublicPolicy=false : N'empêche pas les politiques publiques
## RestrictPublicBuckets=false : Ne restreint pas l'accès public aux buckets

## awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/put-bucket-policy.html#examples

## create bucket policy
## docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteAccessPermissionsReqd.html
## Cette commande AWS CLI applique une politique (policy) à un bucket S3 nommé "cors-fun-ab-3625" en utilisant le contenu d'un fichier JSON local appelé "bucket-policy.json".
```sh
aws s3api put-bucket-policy --bucket cors-fun-ab-36252 --policy file://bucket-policy.json
```

## turn on static web hosting 
## Cette commande AWS CLI configure un bucket S3 nommé "cors-fun-ab-36252" pour l'hébergement de site web statique en utilisant les paramètres définis dans le fichier local "website.json" 
```sh
aws s3api put-bucket-website --bucket cors-fun-ab-36252 --website-configuration file://website.json
```

## Upload our index.html file and include a resource that would be cross-origin
```sh
aws s3 cp index.html s3://cors-fun-ab-36252
```

## Get the website endpoint for S3
```sh
aws s3api get-bucket-website --bucket cors-fun-ab-36252
```

## View the website and see if the index.html is there.
## this 
http://cors-fun-ab-36252.s3-website.ca-central-1.amazonaws.com
## or this 
http://cors-fun-ab-36252.s3-website-ca-central-1.amazonaws.com

## create website 2

## create a buket
##  
```sh
aws s3 mb s3://cb-fun2-ab-36252
```
## change block public access
```sh
aws s3api put-public-access-block \
--bucket cb-fun2-ab-36252 \
--public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=false,RestrictPublicBuckets=false"

```

## Cette commande AWS CLI configure les paramètres de blocage d'accès public pour un bucket S3 nommé "cb-fun-ab-36252" avec les options suivantes :
```sh
aws s3api put-bucket-policy --bucket cors-fun2-ab-36252 --policy file://bucket-policy2.json
```

## turn on static web hosting 
```sh
aws s3api put-bucket-website --bucket cors-fun2-ab-36252 --website-configuration file://website.json
```

## upload our javascript file
aws s3 cp hello.js s3://cors-fun2-ab-36252
## http://cors-fun2-ab-36252.s3-website.ca-central-1.amazonaws.com/hello.js

## Upload our index.html file and include a resource that would be cross-origin
```sh
aws s3 cp index.html s3://cors-fun2-ab-36252
```

## ca-central-1.console.aws.amazon.com/apigateway/main/apis?region=ca-central-1
## docs.aws.amazon.com/apigateway/latest/developerguide/models-mappings.html
## docs.aws.amazon.com/apigateway/latest/developerguide/how-to-mock-integration-console.html

## Create API Gateway with mock response and then test the endpoint
```sh
curl -X POST -H "Content-Type: application/json" https://1kccnjkm43.execute-api.ca-central-1.amazonaws.com/prod/hello
```

## developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest/send
## awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/put-bucket-cors.html#examples

## Set CORS on our bucket
```sh```
aws s3api put-bucket-cors --bucket cors-fun-ab-36252 --cors-configuration file://cors.json
```
## developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Allow-Origin
## CORS stands for Cross-Origin Resource Sharing. It's a browser security mechanism that controls how web pages can request resources from a different domain than the one that served the page. Example of the problem: Your webpage is hosted at https://mysite.com It tries to fetch data from https://api.otherdomain.com The browser blocks this by default — that's the Same-Origin Policy

## CORS solves this by letting the server tell the browser:

# "Yes, I allow requests from this other origin."

# This is done via HTTP response headers like:
# Access-Control-Allow-Origin: https://mysite.com
# Access-Control-Allow-Methods: GET, POST
# Access-Control-Allow-Headers: Authorization
## Your S3 bucket serves files from one origin Your API Gateway is on another origin You configured CORS on the S3 bucket so that the API Gateway URL (https://1kccnjkm43.execute-api.ca-central-1.amazonaws.com) is allowed to make requests to it Without CORS configured, the browser would block those cross-origin requests entirely.
