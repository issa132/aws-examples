## Client-Side Encryption (CSE) when data is encrypted by the client and then sent to the server
# The client has the key, the server will serve the encrypted file since it does not have the key to decrypt when data is requested

## Server-Side Encryption (SSE) when data is encrypted by the server
# The server has the key to decrypt when data is requested. it is always on 
# SSE-S3 Amazon S3 manages the keys, encrypts using AES-GCM (256-bit) algorithm
# SSE-KMS AWS Key Management Service (KMS) and you manage the keys
# SSE-C Customer provided key (you manage the keys)
# DDSE-KMS Dual-layer server-side encryption. Encrypts client side than server side.



# Encryption In-Transit Data that is secure when moving between locations Algorithms: TLS (transport layer security), SSL (secure sockets layer )

# docs.aws.amazon.com/cli/latest/reference/s3api/
# awscli.amazonaws.com/v2/documentation/api/latest/reference/kms/index.html
# awscli.amazonaws.com/v2/documentation/api/latest/reference/kms/create-key.html

# Create a bucket
 aws s3 mb s3://encryption-fun-ab-135
# Create a file and put object with encryption SS3-S3
 echo "Hello World" > hello.txt
 aws s3 cp hello.txt s3://encryption-fun-ab-135
# Put Object with encryption of SS3-KMS

```sh
aws s3api put-object \
--bucket encryption-fun-ab-135 \
--key hello.txt \
--body hello.txt \
--server-side-encryption "aws:kms" \
--ssekms-key-id "a1bb2b48-ce90-49ff-bd06-f23705bcc0d8"
```

# to download the file
aws s3 cp s3://encryption-fun-ab-135/hello.txt hello.txt



# Put Object with SSE-C [Failed Attempt]
bashexport BASE64_ENCODED_KEY=$(openssl rand -base64 32)
echo $BASE64_ENCODED_KEY

export MD5_VALUE=$(echo $BASE64_ENCODED_KEY | md5sum | awk '{print $1}' | base64 -w0)
echo $MD5_VALUE

```sh
aws s3api put-object \
--bucket encryption-fun-ab-135 \
--key hello.txt \
--body hello.txt \
--sse-customer-algorithm AES256 \
--sse-customer-key $BASE64_ENCODED_KEY \
#--sse-customer-key-md5 $MD5_VALUE
An error occurred (InvalidArgument) when calling the PutObject operation: The calculated MD5 hash of the key did not match the hash that was provided.
```

# support.us.ovhcloud.com/hc/en-us/articles/10694235769747-How-to-Encrypt-Your-Server-Side-Objects-with-SSE-C
# catalog.us-east-1.prod.workshops.aws/workshops/aad9ff1e-b607-45bc-893f-121ea522424/en-US/s3/serverside/ssec
openssl rand -out ssec.key 32

aws s3 cp hello.txt s3://encryption-fun-ab-135/hello.txt \
--sse-c AES256 \
--sse-c-key fileb://ssec.key

# to download the file
aws s3 cp s3://encryption-fun-ab-135/hello.txt hello.txt --sse-c AES256 --sse-c-key fileb://ssec.key