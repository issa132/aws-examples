# brew install yq
# for all ressources anywhere s3 , En résumé, cette politique accorde un accès total à tous les services et ressources S3.
# yq -o json policy.yml > policy.json ceci pour convertir yml file to json 

# convert to json
```sh
yq -o json policy.yml > policy.json
```

The bash script
```sh
./update
```

# chmod u+x policy.json
# ls -la

# awscli.amazonaws.com/v2/documentation/api/latest/reference/iam/create-policy.html#examples
```sh
aws iam create-policy \
--policy-name my-fun-policy \
--policy-document file://policy.json
```

# update policy
# awscli.amazonaws.com/v2/documentation/api/latest/reference/iam/create-policy-version.html#examples
```sh
aws iam create-policy-version \
--policy-arn arn:aws:iam::982383527471:policy/my-fun-policy \
--policy-document file://policy.json \
--set-as-default
```

# attach policy to an user 
# awscli.amazonaws.com/v2/documentation/api/latest/reference/iam/attach-user-policy.html
```sh
aws iam attach-user-policy \
--policy-arn arn:aws:iam::982383527471:policy/my-fun-policy \
--user-name aws-examples
```

# on peut aussi faire le update ainsi: 
```sh
aws iam create-policy-version \
--policy-arn arn:aws:iam::982383527471:policy/my-fun-policy \
--policy-document "$(yq -o json policy.yml)" \
--set-as-default
```

# la seule action est de lister les buckets 
Version: "2012-10-17"
Statement:
  - Sid: "AccessToS3"
    Effect: "Allow"
    Action: "s3:ListBucket"
    Resource: "*"


# this should only list this bucket: arn:aws:s3:::mycoolbucket-ab-1412
# docs.aws.amazon.com/service-authorization/latest/reference/list_amazons3.html
Version: "2012-10-17"
Statement:
  - Sid: "AccessToS3"
    Effect: "Allow"
    Action: "s3:ListBucket"
    Resource: "arn:aws:s3:::mycoolbucket-ab-1412"

# now we are saying all buckets
Version: "2012-10-17"
Statement:
  - Sid: "AccessToS3"
    Effect: "Allow"
    Action: "s3:ListBucket"
    Resource: "arn:aws:s3:::*"


# deleting policy
aws iam delete-policy-version \
--policy-arn arn:aws:iam::982383527471:policy/my-fun-policy \
--version-id v2

# list all our buckets 
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": [
        "s3:*",
        "s3:ListBucket"
      ],
      "Resource": "*"
    }
  ]
}

# bobcares.com/blog/aws-s3-listobjects-access-denied/

{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::*",
      "Condition": {
        "StringEquals": {
          "s3:prefix": "hello"
        }
      }
    },
    {
      "Sid": "VisualEditor1",
      "Effect": "Allow",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::*/*"
    }
  ]
}

Cette politique IAM fait deux choses :
Statement 1 — ListBucket avec condition
Elle autorise l'action s3:ListBucket (lister le contenu d'un bucket) sur tous les buckets S3 (arn:aws:s3:::*), mais uniquement si le préfixe des objets est "hello". Cela signifie que l'utilisateur ne peut lister que les objets dont le nom commence par hello/.
Statement 2 — GetObject
Elle autorise l'action s3:GetObject (télécharger/lire un objet) sur tous les objets de tous les buckets (arn:aws:s3:::*/*), sans condition.

# The Root User account has full permissions to the account and its permissions cannot be limited.
    You cannot use IAM policies to explicitly deny the root user access to resources.
    You can only use an AWS Organizations service control policy (SCP) to limit the permissions of the root user


# docs.aws.amazon.com/cli/latest/userguide/cli-authentication-user.html#cli-authentication-user-configure.title
# awscli.amazonaws.com/v2/documentation/api/latest/reference/iam/create-access-key.html#examples
# docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html#envvars-list-aws_cli_auto_prompt

```sh
export AWS_CLI_AUTO_PROMPT=on-partial
aws
aws iam create-access-key --user-name aws-examples
aws iam delete-access-key --user-name aws-examples --access-key-id AKIA6JOU7AYXYCKDKIVY
```


# Temporary credentials are just like Programmatic Access Keys except they are temporary.
Temporary credentials are useful in scenarios that involve:

  identity federation,
  delegation,
  cross-account access,
  and IAM roles

They can last from minutes to an hour.
They are not stored with the user but are generated dynamically and provided to the user when requested.
They are the basis for roles and identity federation.

You are already using Temporary Security Credentials. AWS automatically generates them for IAM Roles.


# What is Identity Federation?
The means of linking a person's electronic identity and attributes, stored across multiple distinct identity management systems
Identity Federation allows users to exist on a different platform. eg Users are on Facebook but gain access as if they are a user in AWS
IAM supports ✌ two types of identity federation

Enterprise identity federation

  SAML (Microsoft Active Directory)
  Custom Federation broker

Web identity federation

  Amazon
  Facebook
  Google
  OpenID Connect (OIDC) 2.0


A web service that enables you to request temporary, limited-privilege credentials for IAM users or for federated users
AWS Security Token Service (STS) is a global service, and all AWS STS requests go to a single endpoint at https://sts.amazonaws.com
An STS will return:

  AccessKeyID
  SecretAccessKey
  SessionToken
  Expiration

You can use the following API actions to obtain STS:

  AssumeRole
  AssumeRoleWithSAML
  AssumeRoleWithWebIdentity
  DecodeAuthorizationMessage
  GetAccessKeyInfo
  GetCallerIdentity
  GetFederationToken
  GetSessionToken

# aws sts get-caller-identity --region us-east-2 --endpoint-url https://sts.us-east-2.amazonaws.com

# IAM – Cross Account Roles
You can grant users from different AWS account access to resources in your account through a Cross-Account Role. This allows you to not to have to create them a user account within your system.
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Action": "sts:AssumeRole",
    "Resource": "arn:aws:iam::PRODUCTION-ACCOUNT-ID:role/UpdateApp"
  }
}
The role you create has a policy which grant access to the sts:AssumeRole

# AWS Single Sign-On (AWS SSO) is where you create, or connect, your workforce identities in AWS once and manage access centrally across your AWS organization.
Choose your Identity Source

  AWS SSO
  Active Directory
  SAML 2.0 IdP

Managed User Permissions Centrally

  AWS Account
  AWS Applications
  SAML Applications

Uses get Single Click Access
