# https://github.com/github/gitignore/blob/main/Terraform.gitignore
resource "aws_s3_bucket" "my-s3-bucket" {
  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}