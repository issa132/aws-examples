## docs.aws.amazon.com/AmazonS3/latest/userguide/example-bucket-policies.html?icmpid=docs_amazons3_console
## docs.aws.amazon.com/cli/latest/reference/s3api/put-bucket-policy.html#examples

# Create the bucket
aws s3 mb s3://bucket-policy-example-ab-5235

# Apply a bucket policy from a JSON file
aws s3api put-bucket-policy --bucket bucket-policy-example-ab-5235 --policy file://policy.json


## verifying bucket policy cross-account access (rather than ACL-based access). access bucket in the cross account
# Create a local test file
touch bootcamp.txt

# Test WRITE permission - upload from the other account
aws s3 cp bootcamp.txt s3://bucket-policy-example-ab-5235

# Test READ permission - list the bucket from the other account
aws s3 ls s3://bucket-policy-example-ab-5235