variable "domain_name" {
  type = string
  description = "Domain Name"
}

variable "aws_ses_mail_bucket_name" {
  type = string
  description = "S3 Bucket for Amazon SES incoming mails"
}

variable "cloud_front_origin_name" {
  type = string
  description = "S3 bucket name for Cloudfront"
}

variable "assume_role_user" {
  type = string
  description = "Assume role user"
}

variable "workspace" {
  type = string
  description = "Terraform workspace"
}

variable "environment" {
  type = string
  description = "Environment name"
}

variable "username" {
  type = string
  description = "User name"
}
