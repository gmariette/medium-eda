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

terraform {  
  backend "s3" {    
    bucket = "training-medium-eda-tf-state"   
    key    = "training/tfstate.tf" 
    region = "ca-central-1"   
    }
}

locals {
    vpc_name = "${var.env}-vpc"
}

module "sqs-queues" {
  source = "../modules/sqs-queues"
  env = "${var.env}"
  project = "${var.project}"
  region = "${var.region}"
  aws_account = "${var.aws_account}"
}

module "lambda-functions" {
  source = "../modules/lambda-functions"
  env = "${var.env}"
  project = "${var.project}"
  region = "${var.region}"
  domain_name = "${var.domain_name}"
  depends_on = [module.sqs-queues]

}