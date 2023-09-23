terraform {
  backend "s3" {
    bucket         = "terraform-backend-salpad"
    key            = "terraform.tfstate/dev/vpc"
    region         = "eu-north-1"
    encrypt        = true
  }
}
