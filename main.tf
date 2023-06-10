terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

resource "random_id" "name-prefix" {
  byte_length = 8
}
terraform {
  backend "s3" {
    bucket         = "buket-for-terraform-backend-task1"
    key            = "state/terraform.tfstate"
    dynamodb_table = "terraform-state-lock-dynamo"
    region         = "us-east-1"
  }
}


provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}
