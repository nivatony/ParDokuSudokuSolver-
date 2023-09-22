terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5"
    }
  }
}

provider "aws" {
  region = "us-east-1" # You can specify the AWS region here if it's different from the default region configured in your AWS CLI or environment.
}

   backend "s3" {
    bucket = "terraform-backend-salpad-1"
    key    = "terraform.tfstate/dev/vpc"
    region = "us-east-1"
}

