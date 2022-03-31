provider "aws" {
  region = var.region

  allowed_account_ids = var.allowed_account_ids
  default_tags {
    tags = {
      Environment = var.env
      Owner       = var.owner
      Terraform   = "true"
    }
  }
}

module "iam" {
  source = "../modules/iam"
  env = "${var.env}"
  project = "${var.project}"
  region = "${var.region}"
  aws_account = "${var.aws_account}"
}

module "sqs-queues" {
  source = "../modules/sqs-queues"
  env = "${var.env}"
  project = "${var.project}"
  region = "${var.region}"
  aws_account = "${var.aws_account}"
  depends_on = [module.iam]
}

module "lambda-functions" {
  source = "../modules/lambda-functions"
  env = "${var.env}"
  project = "${var.project}"
  region = "${var.region}"
  depends_on = [module.sqs-queues, module.iam]

}