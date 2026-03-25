## docs.aws.amazon.com/AmazonS3/latest/userguide/example-bucket-policies.html?icmpid=docs_amazons3_console
## docs.aws.amazon.com/cli/latest/reference/s3api/put-bucket-policy.html#examples

# Create the bucket
aws s3 mb s3://bucket-policy-example-ab-5235

# Apply a bucket policy from a JSON file
aws s3api put-bucket-policy --bucket bucket-policy-example-ab-5235 --policy file://policy.json

