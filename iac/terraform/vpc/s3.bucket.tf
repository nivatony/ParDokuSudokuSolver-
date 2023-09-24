terraform {
  backend "s3" {
    bucket         = "cf-templates-1gvzivy3mwpjd-eu-north-1"
    key            = "terraform.tfstate/dev/vpc"
    region         = "eu-north-1"
    encrypt        = true
  }
}
