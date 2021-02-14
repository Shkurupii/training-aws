variable "bucket_name" {
  type = string
  description = "An S3 bucket name for Cloudfront"
}

variable "prefix" {
  type = string
  description = "A prefix for s3 bucket name"
  default = "s3"
}
