#Calcule le hash MD5 du fichier — si le fichier change, Terraform détecte la différence et re-uploade automatiquement.
#Déployer
#terraform init
#terraform apply
#terraform plan
#terraform apply --auto-approve
# aws s3 ls s3://terraform-20231214191427287500000001
# aws s3 cp s3://terraform-20231214191427287500000001/myfile.txt myfile.txt | cat
#terraform destroy


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

resource "aws_s3_bucket" "default" {
  bucket = "mon-bucket-unique-123"
}

resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.default.id
  key    = "myfile.txt"
  source = "myfile.txt"
  #etags if the content has change and checksum for data integrity
  etag   = filemd5("myfile.txt")
}