variable "env" {}
variable "project" {}
variable "region" {}

#IAM
data "aws_iam_role" "basic_lambda" {
  name = "${var.project}-${var.env}-iam-role-lambda-trigger"
}

data "aws_iam_role" "put_sqs" {
  name = "${var.project}-${var.env}-put-sqs-lambda-iam-role"
}

data "aws_iam_role" "rd_sqs" {
  name = "${var.project}-${var.env}-rd-sqs-lambda-iam-role"
}

# SQS Datasource
data "aws_sqs_queue" "submit" {
  name = "${var.project}-${var.env}-submit"
}

# Lambda zip
data "archive_file" "lambda_submit" {
  type        = "zip"
  source_file = "${path.module}/source-code/submit.py"
  output_path = "lambda_submit.zip"
}

data "archive_file" "lambda_create" {
  type        = "zip"
  source_file = "${path.module}/source-code/create.py"
  output_path = "lambda_create.zip"
}