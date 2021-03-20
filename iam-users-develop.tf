module "develop-iam-credentials" {
  source = "git::git@github.com:Shkurupii/training-aws.git//modules/iam-credentials"
  account_id = var.develop_account_id
  account_user = var.develop_account_user
}
