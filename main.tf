terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.1.0"
    }
  }
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

