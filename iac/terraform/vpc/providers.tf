terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5"
    }
  }
}
   backend "s3" {
     bucket = "terraform-backend-salpad"
     key    = "terraform.tfstate/dev/vpc"
     region = "eu-north-1"
}
