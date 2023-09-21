terraform {
  backend "s3" {
    bucket = "terraform-backend-salpad-1"
    key    = "terraform.tfstate/dev/vpc"
    region = "global"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5"
    }
  }
}

provider "aws" {
}

