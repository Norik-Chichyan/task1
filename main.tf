terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.1.0"
    random = "~> 0.9.0"
    }
  }
}

resource "random_id" "name-prefix" {
  byte_length = 8
}
#terraform {
#  backend "s3" {
#    bucket         = "terraform-state-github-actions"
#    key            = "state/terraform.tfstate"
#    dynamodb_table = "terraform-state-lock-dynamo"
#    region         = "us-east-1"
#  }
#}


provider "aws" {
  region = "us-east-1"
}

#module "cloudfront" {
#  source  = "terraform-aws-modules/cloudfront/aws"
#  version = "3.2.1"
#}

data "aws_caller_identity" "current" {}

resource "random_string" "random" {
  length           = 6
  special          = true
  override_special = "/@£$"
}