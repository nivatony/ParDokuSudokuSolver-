terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5"
    }
  }
}

provider "kubernetes" {
  config_path    = pathexpand("./ParDokuSudokuSolver-/.kube_config.yaml")  # Set to the correct path of your kubeconfig file
  config_context = "arn:aws:eks:eu-north-1:712699700534:cluster/awesome_cluster"
}

