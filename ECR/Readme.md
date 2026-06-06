# Elastic Container Registry (ECR)
A fully-managed Docker container registry that makes it easy for developers to store, manage, and deploy Docker container images.


    ECR lets you store Docker and Open Container Initiative (OCI) images and artifacts
    You can control private register access via Register policy
    You can control private repo access via a Repo Policy
    You can scan images on push to identify software vulnerabilities
    Private image replication allows you to have cross-account and cross-region images
    With ECR you can create a Pull Through Cache to sync the contents of an upstream registry
    ECR encrypts-at-rest repo images
    Amazon ECR lifecycle allow you to manage automate the cleaning up container images
    You can sign images via AWS Signer to ensure images are from your trusted developers


 
A registry contains multiple repo(sitorie)s
A repo contains multiple images
A image can have multiple tags
A tag points to a specific image version
    Eg. 1.0, latest

# ECR supports:

Public registries — accessible to anyone
Private registries — only accessible to those within the AWS Account

    Control access via Register Policy
        ecr:ReplicateImage
        ecr:BatchImportUpstreamImage
        ecr:CreateRepository

    Control access via Repo Policy
        ecr:DescribeImages
        ecr:DescribeRepositories


## To push to ECR you must first remotely login using docker. You need to have authorization token and have AWS Credentials configure in your environment to get said token.
# Log into ECR
aws ecr get-login-password --region ca-central-1 | docker login \
--username AWS \
--password-stdin 012345678912.dkr.ecr.ca-central-1.amazonaws.com

# Build Image
docker build -t my-image .
# Tag Image
docker tag my-image:latest <ECR_URI>:latest

# Push to ECR
docker push <ECR_URI>:latest

## Image tag mutability feature prevent image tags from being overwritten
aws ecr create-repository \
--repository-name name \
--image-tag-mutability IMMUTABLE \
--region ca-central-1

When tag immutability is turned on for a repository, this affects all tags and you cannot make some tags immutable while others aren't.

💡 Immutable tags is a best practice because if there was a security vulnerability with a specific image you can rollback to previous image or preserve the history of vulnerabilities

ImageTagAlreadyExistsException error is returned if you attempt to push an image with a tag that is already in the repository

ECR Lifecycle policy can be used to expire old images based on specific criteria.

{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Expire images older than 14 days",
      "selection": {
        "tagStatus": "tagged",
        "tagPatternList": ["prod*"],
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": 14
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}

