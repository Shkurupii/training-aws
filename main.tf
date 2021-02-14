terraform {
  required_version = "0.14.5"
}

provider "aws" {
}

module "acm" {
  source = "git::git@github.com:Shkurupii/training-aws-modules.git//modules/acm"
  domain_name = var.domain_name
}

module "ses" {
  source = "git::git@github.com:Shkurupii/training-aws-modules.git//modules/ses"
  domain_name = var.domain_name
  aws_ses_mail_bucket_name = var.aws_ses_mail_bucket_name
}

module "cloudfront" {
  source = "./modules/cloudfront"
  bucket_name = var.cloud_front_origin_name
}
