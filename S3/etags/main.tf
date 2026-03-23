#Calcule le hash MD5 du fichier — si le fichier change, Terraform détecte la différence et re-uploade automatiquement.
#Déployer
#terraform init
#terraform apply

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.30.0"
    }
  }
}

provider "aws" {
  region = "ca-central-1"
}

resource "aws_s3_bucket1" "default" {
  bucket = "mon-bucket-unique-123"
}

resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.default.id
  key    = "myfile.txt"
  source = "myfile.txt"
  etag   = filemd5("myfile.txt")
}