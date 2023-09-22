terraform {
  backend "s3" {
    bucket         = "terraform-backend-salpad-1"
    key            = "terraform.tfstate/dev/vpc"
    region         = "us-east-2"
    encrypt        = true
  }
}
