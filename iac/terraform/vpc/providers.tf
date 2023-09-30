terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws" 
      version = "~> 5"
    } 
  } 
}

provider "kubernetes" {
            
  config_path    = "ParDokuSudokuSolver-/.kube/config" # Set to the correct path of your kubeconfig file

}

