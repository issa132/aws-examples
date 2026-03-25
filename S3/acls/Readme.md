
## Create the bucket
aws s3api create-bucket --bucket acl-example-ab-5235 --region us-east-1

## Turn off Block Public Access for ACLs
```sh
aws s3api put-public-access-block \
--bucket acl-example-ab-5235 \
--public-access-block-configuration "BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=true,RestrictPublicBuckets=true"
```

```sh
aws s3api get-public-access-block --bucket acl-example-ab-5235 
```

## change the bucket ownership
```sh
aws s3api put-bucket-ownership-controls \
--bucket acl-example-ab-5235 \
--ownership-controls="Rules=[{ObjectOwnership=BucketOwnerPreferred}]"
```

## for canonical ID in aws
```sh
aws s3api list-buckets --query Owner.ID --output text
```

##  modify a bucket's ACL to grant access to external users
##  awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/put-bucket-acl.html#examples
##  docs.aws.amazon.com/AmazonS3/latest/userguide/acl-overview.html
##  awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/put-bucket-acl.html
```sh
aws s3api put-bucket-acl
--bucket MyBucket
--grant-full-control emailaddress=user1@example.com,emailaddress=user2@example.com
--grant-read uri=http://acs.amazonaws.com/groups/global/AllUsers
```

```sh
aws s3api put-bucket-acl \
--bucket acl-example-ab-5235 \
--access-control-policy file:///workspace/AWS-Examples/s3/acls/policy.json
```

```sh
## test cross-account bucket access:
# Create an empty test file
touch bootcamp.txt

# Upload the file to the bucket from another account
aws s3 cp bootcamp.txt s3://acl-example-ab-5235

# List the bucket contents from another account
aws s3 ls s3://acl-example-ab-5235

## cleanup
# Remove the uploaded file from the bucket
aws s3 rm s3://acl-example-ab-5235/bootcamp.txt

# Remove (delete) the bucket itself
aws s3 rb s3://acl-example-ab-5235
```