variable "audit_account_id" {
  default = ""
}

locals {
  audit_assume_role_arn = "arn:aws:iam::${var.audit_account_id}:role/OrganizationAccountAccessRole"
}

provider "aws" {
  alias = "audit"
  assume_role {
    role_arn = local.audit_assume_role_arn
  }
}
