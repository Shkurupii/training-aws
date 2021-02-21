variable "develop_account_access_role" {
  type = string
  description = "Develop-Account-Access-Role ARN"
}

provider "aws" {
  alias = "develop"
  assume_role {
    role_arn = var.develop_account_access_role
  }
}

resource "aws_s3_bucket" "develop-s3" {
  provider = aws.develop
  force_destroy = true
  bucket_prefix = "develop-s3-"
}
