module "iam-credentials" {
  source = "./modules/iam-credentials"
  account_id = var.audit_account_id
  account_user = var.audit_account_user
}
