## Create a bucket
aws s3 mb s3://encrypt-client-fun-ab-634232

# we dont need to create a file we can just run encrypt.rb
## Create a file
echo "Hello World" > hello.txt

# bundle init
# in gemfile
# gem 'aws-sdk-s3'
# gem 'ox'
# gem 'pry'
# docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/S3/Encryption.html
# bundle install
# bundle exec ruby encrypt.rb

# S3 Lifecycle allows you to automate the storage class changes, archival or deletion of objects There are two type of Actions: Transition Actions and Expiring Actions

# S3 Transfer Acceleration is a bucket-level feature that provides fast and secure transfer of files over long distances between your end users and an S3 bucket.

# Instead of uploading to your bucket, users use a distinct endpoint to route to an edge location. exemple of endpoint:  https://s3-accelerate.amazonaws.com  and https://s3-accelerate.dualstack.amazonaws.com 

# S3 Presigned Urls provides temporary access to upload or download object data via URL.
```sh
aws s3 presign s3://mybucket/myobject \
--expires-in 300
```

# S3 Access Points simplify managing data access at scale for shared datasets in S3. S3 Access Points are named network endpoints that are attached to buckets that you can use to perform S3 object operations eg. Get, Put

# Instead of creating a Bucket Policy you can create multiple access points that allow you to apply policies to parts of your bucket's content

# AWS Global Accelerator is used to route to the closest bucket

# S3 Object Lambda Access Points allows you to transform the output requests of S3 objects when you want present data differently.Par exemple lorsque tu veux cacher certaines informations dans tes données a quelqu'Un ou une équipe

# Mountpoint for Amazon S3 allows you to mount an S3 bucket to your Linux local file system.

# installing mountpoint
# wget https://s3.amazonaws.com/mountpoint-s3-release/latest/x86_64/mount-s3.rpm
# sudo yum install ./mount-s3.rpm
# mount-s3 --version

# Using Mountpoint
# mkdir ~/mnt
# mount-s3 mybucket ~/mnt
# cd mnt
# perform basic operations
# eg. cat, ls, pwd
# umount ~/mnt

# Archive storages classes
# Archived Objects are rarely-access objects Amazon S3 that cannot be accessed in real-time in exchange for a reduced storage-cost.
# S3 Glacier Flexible Retrieval: Minutes to hours
# S3 Glacier Deep Archive: +12 hours

# Archive access tiers 
# S3 Intelligent-Tiering Archive Access tier: Within minutes
# S3 Intelligent-Tiering Deep Archive Access : 12+ hours 

# Requesters Pays bucket option allow the bucket owner to offset specific S3 costs to the requester (the user requesting the data).
# When you want to share data but not incur the charges associated with others accessing the data. Eg.
# Collaborative Projects: External partners pay for their own S3 data uploads/downloads.
# Client Data Storage: Clients pay for their S3 storage and transfer costs.

# In the case the requesters forgets to include the header, than 403 will occur, no charge will occur to the requester. No charge will occur to the bucket owner.

# The AWS Marketplace for S3 provides alternatives to AWS Services that work with Amazon S3

# S3 Batch Operations performs large-scale batch operations on Amazon S3 objects billions of objects containing exabytes of data The follow Batch Operation Types can be performed:
# Copy Copies each object listed in the manifest to the specified destination bucket.
# Invoke AWS Lambda function Run a Lambda function against each object
# Replace all object tags Replaces the Amazon S3 object tags of each object
# Replace access control list (ACL) Replaces the (ACLs) for each object
# Restore Sends a restore request to S3 Glacier
# Object Lock retention Prevents overwriting or deleting for a fixed amount of time.
# Object Lock legal hold Prevents overwriting or deleting until the legal hold is removed.

# Amazon S3 Inventory takes inventory of objects in an S3 bucket on a repeating schedule so you have an audit history of object changes.

## S3 Select lets you use a Structured Query Language (SQL) to filter the contents of S3 objects
```sh
aws s3api select-object-content \
--bucket my-bucket \
--key my-data-file.csv \
--expression "select * from s3object limit 100" \
--expression-type 'SQL' \
--input-serialization '{"CSV": {}, "CompressionType": "NONE"}' \
--output-serialization '{"CSV": {}}' "output.csv"
```

## S3 Event Notifications allows your bucket to notify other AWS Services about s3 event data.
# Notification events
# New object created events
# Object removal events
# Restore object events
# Reduced Redundancy Storage (RRS) object lost events
# Replication events
# S3 Lifecycle expiration events
# S3 Lifecycle transition events
# S3 Intelligent-Tiering automatic archival events
# Object tagging events
# Object ACL PUT events
# Amazon S3 event notifications are designed to be delivered at least once notifications are delivered in seconds but can sometimes take a minute or longer

## Storage Class Analysis allows you to analyze storage access patterns of objects within a bucket to recommend objects to move between STANDARD to STANDARD_IA. THIS IS COST effective than intelligent tiering
```sh
bashaws s3api put-bucket-analytics-configuration \
--bucket my-bucket --id 1 \
--analytics-configuration '{"Id": "1","StorageClassAnalysis": {}}'
```
# 6Use data in Amazon QuickSight for data visualization


## Amazon S3 Storage Lens is a storage analysis tool for S3 buckets across your entire AWS organization.
# how much storage you have across your organization
# which are the fastest-growing buckets and prefixes
# identify cost-optimization opportunities
# implement data-protection and access-management best practices
# improve the performance of application workloads

# S3 Static Website Hosting allows you to host and serve a static website from an S3 bucket.

## Amazon S3 supports multipart upload so you can upload a single object in a set of parts.
# For files that are +100MB multipart upload is recommended
```sh
aws s3api create-multipart-upload \
--bucket my-bucket \
--key 'myfile'
```
```sh
aws s3api upload-part \
--bucket my-bucket \
--key 'myfile' \
--part-number 1 \
--body part01 \
--upload-id "dfRtDYU0WWCCcH43C..."
```
```sh
aws s3api complete-multipart-upload \
--bucket my-bucket \
--key 'myfile' \
--multipart-upload file://parts.json \
--upload-id "dfRtDYU0WWCCcH43C..."
```
# Then we tell S3 we have finished upload
# We'll provide a JSON file with Etags corresponding to each part
```sh
{"Parts": [
  {"PartNumber": 1, "ETag": "\"81e5e6e31c8430d7625c9c2b98e13c58\""},
  {"PartNumber": 2, "ETag": "\"7f7c47e44d8c0f5f8c7d0c8b8e8b7f24\""},
  {"PartNumber": 3, "ETag": "\"56ab24f6b5e0a50c2c3b9d58a3dabfb2\""}
]}
```
# Amazon S3 allows you to fetch a range of bytes of data from S3 Objects using the Range header during S3 GetObject API Requests.
```py
import boto3

s3 = boto3.client('s3')
bucket_name = 'your-bucket-name'
object_key = 'your-object-key'

# Get the first 100 bytes
byte_range = 'bytes=0-99'
response = s3.get_object(Bucket='mybucket', Key='myobject.txt', Range=byte_range)

# Read the partial content
data = response['Body'].read()
```
## Interoperability in the context of cloud services is the capability of cloud services to exchange and utilize information seamlessly with each other.
# Amazon EC2: Stores snapshots and backups in S3.
# Amazon RDS: Backups and data exports to S3.
# AWS CloudTrail: Stores API call logs in S3.
# Amazon CloudWatch Logs: Exports logs/metrics to S3.
# AWS Lambda: Outputs data/logs to S3.
# AWS Glue: ETL results stored in S3.
# Amazon Kinesis: Data streaming to S3 via Firehose.
# Amazon EMR: Uses S3 for input/output data storage.
# Amazon Redshift: Unloads data to S3.
# AWS Data Pipeline: Moves/transforms data to/from S3.
# Amazon Athena: Outputs query results to S3.
# AWS IoT Core: Stores IoT data in S3.

