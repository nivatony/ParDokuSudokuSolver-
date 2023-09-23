terraform {
  backend "s3" {
    bucket         = "terraform-backend-salpad"
    key            = "terraform.tfstate/dev/vpc"
    region         = "global"
    encrypt        = true
  }
}
