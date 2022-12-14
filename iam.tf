resource "aws_iam_instance_profile" "profile" {
  name = "${var.prefix}-${var.environment}-instance-profile"
  role = aws_iam_role.role.name
}

resource "aws_iam_role" "role" {
  name = "${var.prefix}-${var.environment}-service-role"
  assume_role_policy = data.aws_iam_policy_document.assume-role-policy.json
  inline_policy {
    name = "${var.prefix}-${var.environment}-inline-policy"
    policy = data.aws_iam_policy_document.inline_policy.json
  }
}

resource "aws_iam_role" "lambda_role" {
  name = "${var.prefix}-${var.environment}-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
  inline_policy {
    name = "${var.prefix}-${var.environment}-lambda-inline-policy"
    policy = data.aws_iam_policy_document.lambda_inline_policy.json
  }
}