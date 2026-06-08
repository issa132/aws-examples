# Secrets Manager
Protect secrets needed to access your applications and services. Easily rotate, manage, and retrieve database credentials, API keys, and other secrets throughout their lifecycle.

Secrets Manager's is mostly used to store and automatically rotate database credentials.
Enforces encryption at-rest by using KMS.

# PricingPricing

    $0.40 per secret per month
    $0.05 per 10,000 API calls

CloudTrail can monitor credentials access in case you need to audit.CloudTrail can monitor credentials access in case you need to audit.

# Secrets Manager – Automatic rotationSecrets Manager – Automatic rotation
    You can setup automatic rotation for any database credentials.
    You can rotate up to 365 days (1 year).
    Rotation is performed via a Lambda function.

You can rotate the password for the superuser or for a developer programmatically accessing the database.
# Secrets Manager – CLI
bash
aws secretsmanager describe-secret --secret-id enterprise/ShipDatabase
json
{
    "ARN": "arn:aws:secretsmanager:region:123456789012:secret:enterprise/ShipDatabase-jiObOV",
    "Name": "enterprise/ShipDatabase",
    "Description": "Core Database",
    "LastChangedDate": 1522680794.8,
    "LastAccessedDate": 1522627200.0,
    "VersionIdsToStages": {
        "EXAMPLE1-90ab-cdef-fedc-ba987EXAMPLE": [
            "AWSCURRENT"
        ]
    }
}

aws secretsmanager get-secret-value --secret-id enterprise/ShipDatabase --version-stage AWSCURRENT

{
    "ARN": "arn:aws:secretsmanager:region:123456789012:secret:enterprise/ShipDatabase-jiObOV",
    "Name": "enterprise/ShipDatabase",
    "VersionId": "EXAMPLE1-90ab-cdef-fedc-ba987EXAMPLE",
    "SecretString": "{\"username\":\"worf\",\"password\":\"delta-omega-beta\"}",
    "VersionStages": [
        "AWSCURRENT"
    ],
    "CreatedDate": 1522680764.668
}

# docs.docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-secretsmanager-secret.html

# gemfile: 
source "https://rubygems.org"

# gem "rails"
gem 'aws-sdk-secretsmanager'
gem 'ox'
gem 'pry'



