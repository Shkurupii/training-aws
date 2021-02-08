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
