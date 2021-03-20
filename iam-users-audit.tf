module "audit-iam-credentials" {
  source = "git::git@github.com:Shkurupii/training-aws.git//modules/iam-credentials"
  account_id = var.audit_account_id
  account_user = var.audit_account_user
}
