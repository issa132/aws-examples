# create a new bucket, mb = make bucket
```md

aws s3 mb s3://checksums-examples-ab-2342

```

# Create a file that will we do a checksum on
# aws.amazon.com/getting-started/hands-on/amazon-s3-with-additional-checksums/
```md
aws s3 mb s3://checksums-examples-ab-2342

```

```md
# Get a checksum of a file for md5
md5sum myfile.txt
# 8ed2d86f12620cdba4c976ff6651637f  myfile.txt
```

```md
# Upload our file and look at its etag

aws s3 cp myfile.txt s3://checksums-examples-ab-2342
aws s3api head-object --bucket checksums-examples-ab-2342 --key myfile.txt

#voici le resultat: 
# {
#  "AcceptRanges": "bytes",
#  "LastModified": "2023-12-14T19:39:31+00:00",
#  "ContentLength": 11,
#  "ETag": "\"8ed2d86f12620cdba4c976ff6651637f\"",
#  "ContentType": "text/plain",
#  "ServerSideEncryption": "AES256",
#  "Metadata": {}
# }
```

# awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/put-object.html#examples
Lets upload a file with a different kind of checksum
cksum -o 3 -b myfile.txt


# 
```sh
sudo apt update
sudo apt-get install rhash
sudo apt-get install crc32
rhash --crc32 --simple myfile.txt
rhash --crc32 myfile.txt
```

# 
# aws s3api put-object \
#  --checksum-algorithm="CRC32" \
#  --checksum-crc32


# 
```sh
bundle exec ruby crc.rb
```


```sh
aws s3api put-object \
--bucket="checksums-examples-ab-2342" \
--key="myfilesha1.txt" \
--body="myfile.txt" \
--checksum-algorithm="SHA1" \
--checksum-sha1="c28ccc2c5e214036806014df9fb43634f3e770b2"
```
# aws.amazon.com/blogs/aws/new-additional-checksum-algorithms-for-amazon-s3/
