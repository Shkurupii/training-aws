data "aws_iam_policy_document" "assume_role_policy_document" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"]
    resources = [
      "arn:aws:iam::${var.account_id}:role/OrganizationAccountAccessRole"
    ]
  }
}

resource "random_pet" "assume_role" {}

resource "aws_iam_policy" "assume_role_policy" {
  name = "${random_pet.assume_role.id}-policy"
  description = "Policy for ${var.account_user}"
  policy = data.aws_iam_policy_document.assume_role_policy_document.json
}

# Create a user
resource "aws_iam_user" "assume_role_user" {
  name = var.account_user
  force_destroy = true
}

# Create a key
resource "aws_iam_access_key" "assume_role_user_key" {
  user = aws_iam_user.assume_role_user.name
}

# Attach assume policy
resource "aws_iam_user_policy_attachment" "assume_role_user_attachment" {
  user = aws_iam_user.assume_role_user.name
  policy_arn = aws_iam_policy.assume_role_policy.arn
}

# Create a secret
resource "aws_secretsmanager_secret" "assume_role_user_keys" {
  name_prefix = "${aws_iam_user.assume_role_user.name}-iam-keys-"
  recovery_window_in_days = 7
}

resource "aws_secretsmanager_secret_version" "assume_role_user_keys_version" {
  secret_id = aws_secretsmanager_secret.assume_role_user_keys.id
  secret_string = jsonencode({
    id = aws_iam_access_key.assume_role_user_key.id
    encrypted_secret = aws_iam_access_key.assume_role_user_key.encrypted_secret
    secret = aws_iam_access_key.assume_role_user_key.secret
  })
}
