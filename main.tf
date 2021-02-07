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

resource "aws_acm_certificate" "cert" {
  domain_name               = var.domain_name
  subject_alternative_names = var.alternative_names
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }

}

data "aws_route53_zone" "dns_zone" {
  name         = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "my_record" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      record  = dvo.resource_record_value
      type    = dvo.resource_record_type
      zone_id = data.aws_route53_zone.dns_zone.zone_id
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = each.value.zone_id
}

resource "aws_acm_certificate_validation" "validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.my_record : record.fqdn]
}

resource "aws_ses_domain_identity" "amazonses_di" {
  domain = var.domain_name
}

resource "aws_route53_record" "amazonses_verification_record" {
  zone_id = data.aws_route53_zone.dns_zone.zone_id
  name    = "_amazonses1.${aws_ses_domain_identity.amazonses_di.id}"
  type    = "TXT"
  ttl     = "600"
  records = [aws_ses_domain_identity.amazonses_di.verification_token]
}

resource "aws_ses_domain_identity_verification" "amazonses_di_verification" {
  domain = aws_ses_domain_identity.amazonses_di.id

  depends_on = [aws_route53_record.amazonses_verification_record]
}

resource "aws_ses_receipt_rule_set" "amazonses_receipt_rule_set" {
  rule_set_name = "Main"
}

variable "aws_ses_mail_bucket_name" {
  type = string
  description = "S3 Bucket for Amazon SES incoming mails"
}

resource "aws_ses_receipt_rule" "amazonses_receipt_rule" {
  name          = "Store"
  rule_set_name = aws_ses_receipt_rule_set.amazonses_receipt_rule_set.rule_set_name
  recipients    = [var.domain_name]
  enabled       = true
  scan_enabled  = true

  s3_action {
    bucket_name = var.aws_ses_mail_bucket_name
    object_key_prefix = "mailbox"
    position    = 1
  }
}

resource "aws_ses_active_receipt_rule_set" "amazonses_active_receipt_rule_set" {
  rule_set_name = "Main"
  depends_on = [aws_ses_receipt_rule_set.amazonses_receipt_rule_set]
}

resource "aws_ses_domain_dkim" "amazonses_domain_dkim" {
  domain = aws_ses_domain_identity.amazonses_di.domain
}

resource "aws_route53_record" "amazonses_dkim_record" {
  count   = 3
  zone_id = data.aws_route53_zone.dns_zone.zone_id
  name    = "${element(aws_ses_domain_dkim.amazonses_domain_dkim.dkim_tokens, count.index)}._domainkey.${aws_ses_domain_identity.amazonses_di.id}"
  type    = "CNAME"
  ttl     = "600"
  records = ["${element(aws_ses_domain_dkim.amazonses_domain_dkim.dkim_tokens, count.index)}.dkim.amazonses.com"]
}
