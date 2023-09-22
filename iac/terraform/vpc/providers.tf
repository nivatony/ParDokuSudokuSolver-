terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5"
    }
  }
}

provider "aws" {
  region = "global" # You can specify the AWS region here if it's different from the default region configured in your AWS CLI or environment.
}

   provider "aws" {
    region = "${var.aws_region}"
}


    backend "s3" {
    bucket         = "terraform-backend-salpad-1"
    key            = "terraform.tfstate/dev/vpc"
    region         = "us-east-2"
    encrypt        = true
  }
}

