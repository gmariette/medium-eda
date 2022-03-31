variable "env" {
    description = "Current environment"
    type = string
    default = "dev"
}

variable "project" {
    description = "Project"
    type = string
    default = "medium-eda"  
}

variable "owner" {
    description = "Stack owner"
    type = string
    default = "medium"
}

variable "region" {
    description = "A list of availability zones in the region"
    type        = string
    default     = "ca-central-1"
}

variable "aws_account" {
    description = "AWS account id"
    type = string
    default = 123456789
}

variable "allowed_account_ids" {
    description = "AWS account ids"
    type = list(string)
    default = [ "123456789" ]
}