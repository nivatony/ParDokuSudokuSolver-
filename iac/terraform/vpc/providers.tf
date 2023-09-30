terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5"
    }
  } 
}

provider "kubernetes" {
            
  config_path    = "~/.kube/config/config_a.yaml" # Set to the correct path of your kubeconfig file

}

