terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5"
    }
  }
}
 backend "s3" {
    key = "terraform.tfstate/dev/vpc"
  }
