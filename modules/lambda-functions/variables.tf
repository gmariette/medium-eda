variable "env" {}
variable "project" {}
variable "region" {}
variable "domain_name" {}

# VPC and Subnets
data "aws_availability_zones" "available" {
    state = "available"

    filter {
        name   = "region-name"
        values = ["${var.region}"]
  }
    filter {
        name = "state"
        values = ["available"]
    }
}

data "aws_vpc" "selected" {
    state = "available"
    filter {
        name   = "tag:Name"
        values = ["${var.project}-${var.env}-vpc"]
  }
}

data "aws_subnet_ids" "intra_subnets_id" {
  vpc_id = "${data.aws_vpc.selected.id}"
  tags = {
    Name = "${var.project}-${var.env}-vpc-intra-*"
  }
}

data "aws_subnet_ids" "private_subnets_id" {
  vpc_id = "${data.aws_vpc.selected.id}"
  tags = {
    Name = "${var.project}-${var.env}-vpc-private-*"
  }
}

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