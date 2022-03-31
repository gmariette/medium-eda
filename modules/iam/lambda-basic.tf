data "aws_iam_policy_document" "AWSLambdaTrustPolicy" {
  version = "2012-10-17"
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "allow-ssm" {
  statement {
    sid = "1"

    actions = [
      "ssm:GetParameter"
    ]

    resources = [
      "arn:aws:ssm:${var.region}:${var.aws_account}:parameter/${var.project}/${var.env}/*",
    ]
  }
}

resource "aws_iam_policy" "allow-ssm-policy" {
  name   = "allow-ssm-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.allow-ssm.json
}

resource "aws_iam_role" "iam_role" {
  assume_role_policy = data.aws_iam_policy_document.AWSLambdaTrustPolicy.json
  name               = "${var.project}-${var.env}-iam-role-lambda-trigger"
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment_lambda_basic_execution" {
  role       = aws_iam_role.iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment_lambda_vpc" {
  role       = aws_iam_role.iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment_lambda_ssm" {
  role       = aws_iam_role.iam_role.name
  policy_arn = aws_iam_policy.allow-ssm-policy.arn
}