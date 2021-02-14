provider "aws" {
}

terraform {
  required_version = "0.14.5"
}

resource "random_string" "suffix" {
  length = 4
  special = false
  upper = false
}

locals {
  amz_s3_origin_name = "${var.prefix}-${var.bucket_name}-${random_string.suffix.result}"
  amz_s3_origin_id = "${local.amz_s3_origin_name}-id"
}

resource "aws_s3_bucket" "amz_s3_origin1" {
  force_destroy = true
  bucket = local.amz_s3_origin_name
  acl = "private"
  cors_rule {
    allowed_methods = [
      "GET"]
    allowed_origins = [
      "*"]
  }
}

resource "aws_s3_bucket_public_access_block" "amz_s3_bpab" {
  block_public_acls = true
  block_public_policy = true
  restrict_public_buckets = true
  ignore_public_acls = false
  bucket = aws_s3_bucket.amz_s3_origin1.bucket
}

resource "aws_s3_bucket_object" "index2_html" {
  bucket = aws_s3_bucket.amz_s3_origin1.id
  force_destroy = true
  key = "index.html"
  content = "<h1>Hello, cloud front!</h1>"
  content_type = "text/html"
  cache_control = "max-age=604800"
  acl = "public-read"
  depends_on = [
    aws_s3_bucket_public_access_block.amz_s3_bpab
  ]
}

resource "aws_cloudfront_distribution" "amz_s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.amz_s3_origin1.bucket_regional_domain_name
    origin_id = local.amz_s3_origin_id
  }

  enabled = true
  is_ipv6_enabled = true
  comment = "Some comment"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD"]
    cached_methods = [
      "GET",
      "HEAD"]
    target_origin_id = local.amz_s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations = [
        "UA",
      ]
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}