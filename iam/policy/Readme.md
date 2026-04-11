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

Version: "2012-10-17"
Statement:
  - Sid: "AccessToS3"
    Effect: "Allow"
    Action: "s3:ListBucket"
    Resource: "*"