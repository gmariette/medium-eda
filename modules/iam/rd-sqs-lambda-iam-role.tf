resource "aws_iam_role" "rd-sqs-lambda-iam-role" {
    name = "${var.project}-${var.env}-rd-sqs-lambda-iam-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                "Sid": "",
                "Effect": "Allow",
                "Principal": {
                    "Service": "lambda.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "rd-sqs-lambda-iam-role" {
  policy_arn = "${aws_iam_policy.rd-sqs-lambda-iam-role.arn}"
  role = "${aws_iam_role.rd-sqs-lambda-iam-role.name}"
}

resource "aws_iam_role_policy_attachment" "rd-sqs-lambda-iam-role_attachment_lambda_vpc" {
  role       = aws_iam_role.rd-sqs-lambda-iam-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_policy" "rd-sqs-lambda-iam-role" {
  policy = "${data.aws_iam_policy_document.rd-sqs-lambda-iam-role.json}"
}

resource "aws_iam_role_policy_attachment" "rd-sqs-lambda-iam-role_lambda_ssm" {
  role       = aws_iam_role.rd-sqs-lambda-iam-role.name
  policy_arn = aws_iam_policy.allow-ssm-policy.arn
}

data "aws_iam_policy_document" "rd-sqs-lambda-iam-role" {
  statement {
    sid       = "AllowSQSPermissions"
    effect    = "Allow"
    resources = ["arn:aws:sqs:${var.region}:${var.aws_account}:${var.project}*"]

    actions = [
      "sqs:ChangeMessageVisibility",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:ReceiveMessage",
      "sqs:GetQueueUrl"
    ]
  }

  statement {
    sid       = "AllowInvokingLambdas"
    effect    = "Allow"
    resources = ["arn:aws:lambda:${var.region}:${var.aws_account}:function:*"]
    actions   = ["lambda:InvokeFunction"]
  }

  statement {
    sid       = "AllowCreatingLogGroups"
    effect    = "Allow"
    resources = ["arn:aws:logs:${var.region}:${var.aws_account}:*"]
    actions   = ["logs:CreateLogGroup"]
  }
  statement {
    sid       = "AllowWritingLogs"
    effect    = "Allow"
    resources = ["arn:aws:logs:${var.region}:${var.aws_account}:log-group:/aws/lambda/*:*"]

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }
}