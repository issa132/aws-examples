## AWS CloudTrail
AWS CloudTrail is a service that enables governance, compliance, operational auditing, and risk auditing of your AWS account.
AWS CloudTrail is used to monitor API calls and Actions made on an AWS account.
Easily identify which users and accounts made the call to AWS eg.

Where — Source IP Address
When — EventTime
Who — User, UserAgent
What — Region, Resource, Action

{"Records": [{
    "eventVersion": "1.0",
    "userIdentity": {
        "type": "IAMUser",
        "principalId": "EX_PRINCIPAL_ID",
        "arn": "arn:aws:iam::123456789012:user/Worf",
        "accountId": "123456789012",
        "accessKeyId": "EXAMPLE_KEY_ID",
        "userName": "Worf"
    },
    "eventTime": "2014-03-24T21:11:59Z",
    "eventSource": "iam.amazonaws.com",
    "eventName": "CreateUser",
    "awsRegion": "us-east-1",
    "sourceIPAddress": "127.0.0.1",
    "userAgent": "aws-cli/1.3.2 Python/2.7.5 Windows/10",
    "requestParameters": {"userName": "LaForge"},
    "responseElements": {"user": {
        "createDate": "Mar 24, 2014 9:11:59 PM",
        "userName": "LaForge",
        "arn": "arn:aws:iam::123456789012:user/LaForge",
        "path": "/",
        "userId": "EXAMPLEUSERID"
    }}
}]}

# CloudTrail is already logging by default and will collect logs for last 90 days via Event History.
If you need more than 90 days you need to create a Trail.
Trails are output to S3 and do not have GUI like Event History. To analyze a Trail you'd have to use Amazon Athena.

# awscli.awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudtrail/index.html
# awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudtrail/create-trail.html#examples




# Create a bucket for cloudtrail logs

aws s3 mb s3://my-cloudtrail-ab-1212

# Create bucket policy to allow cloud trail to put to bucket

aws s3api put-bucket-policy --bucket my-cloudtrail-ab-1212 --policy file://bucket-policy.json

# create trail

aws cloudtrail create-trail \
--name MyTrail \
--s3-bucket-name my-cloudtrail-ab-1212 \
--is-multi-region-trail

aws cloudtrail create-trail \
--name MyTrail \
--s3-bucket-name my-cloudtrail-ab-1212 \
--region ca-central-1

#  docs.docs.aws.amazon.com/awscloudtrail/latest/userguide/create-s3-bucket-policy-for-cloudtrail.html
# awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/put-bucket-policy.html#examples

# awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudtrail/start-logging.html#examples

# Start Logging

aws cloudtrail start-logging --name MyTrail

