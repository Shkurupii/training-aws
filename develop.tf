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

module "tags" {
  source = "git::git@github.com:Shkurupii/training-aws-modules.git//modules/tags"
  username = "develop"
  environment = "dev"
  workspace = "workspace"
}

resource "aws_s3_bucket" "develop-s3" {
  provider = aws.develop
  force_destroy = true
  bucket_prefix = "develop-s3-"
  tags = module.tags.all_tags
}
