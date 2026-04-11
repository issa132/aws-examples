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