# awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudtrail/update-trail.html#examples
# docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-required-policy-for-cloudwatch-logs.html
# docs.aws.amazon.com/cli/latest/reference/logs/
# docs.docs.aws.amazon.com/cli/latest/reference/logs/create-log-group.html

# Create CloudWatch Log and stream
aws logs create-log-group --log-group-name mycloudtrail


# Update trail for CloudWatch Logs


aws cloudtrail update-trail \
--name MyTrail \
--cloud-watch-logs-log-group-arn arn:aws:logs:ca-central-1:982383527471:log-group:mycloudtrail:* \
--cloud-watch-logs-role-arn arn:aws:iam::982383527471:role/MyCloudTrail2CloudWatchRole