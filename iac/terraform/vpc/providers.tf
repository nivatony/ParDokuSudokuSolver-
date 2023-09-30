terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws" 
      version = "~> 5"
    } 
  } 
}


provider "kubernetes" {
  host = data.aws_eks_cluster.my_cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args = ["eks", "get-token", "--cluster-name", var.cluster_name]
    command = "aws"
 }
}


#provider "kubernetes" {
            
 # config_path    = "ParDokuSudokuSolver-/.kube/config" # Set to the correct path of your kubeconfig file

#} 
