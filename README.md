# training-aws
training-aws

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | 0.14.5 |

## Providers

No provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alternative\_names | Alternative Domain Names | `list(string)` | n/a | yes |
| aws\_ses\_mail\_bucket\_name | S3 Bucket for Amazon SES incoming mails | `string` | n/a | yes |
| domain\_name | Domain Name | `string` | n/a | yes |

## Outputs

No output.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
