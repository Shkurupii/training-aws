locals {
  account_subdomain = "dev.${var.domain_name}"
}

provider "aws" {
  alias = "develop"
  assume_role {
    role_arn = var.assume_role_arn
  }
}

resource "aws_route53_zone" "develop_route53_zone" {
  provider = aws.develop
  name = local.account_subdomain
  tags = module.tags.all_tags
}

resource "aws_route53_record" "develop_route53_ns_record" {
  zone_id = data.aws_route53_zone.dns_zone.zone_id
  name = local.account_subdomain
  type = "NS"
  ttl = "30"
  records = aws_route53_zone.develop_route53_zone.name_servers
}
