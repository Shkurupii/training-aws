terraform {
  required_version = "0.14.5"
}

provider "aws" {
}

variable "domain_name" {
  type = string
  description = "Domain Name"
}

variable "alternative_names" {
  type = list(string)
  description = "Alternative Domain Names"
}

variable "aws_ses_mail_bucket_name" {
  type = string
  description = "S3 Bucket for Amazon SES incoming mails"
}

module "acm" {
  source = "./modules/acm"
  domain_name = var.domain_name
  alternative_names = var.alternative_names
}

module "ses" {
  source = "./modules/ses"
  domain_name = var.domain_name
  aws_ses_mail_bucket_name = var.aws_ses_mail_bucket_name
}
