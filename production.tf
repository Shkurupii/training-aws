//variable "production_account_access_role" {
//  type = string
//  description = "Production-Account-Access-Role ARN"
//}
//
//provider "aws" {
//  alias = "production"
//  assume_role {
//    role_arn = var.production_account_access_role
//  }
//}
//
//resource "aws_s3_bucket" "production-s3" {
//  provider = aws.production
//  force_destroy = true
//  bucket_prefix = "production-s3-"
//}
