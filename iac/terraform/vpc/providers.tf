terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5"
    }
  }
}

provider "kubernetes" {
  alias   = "eks"
  host    = aws_eks_cluster.my_cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.my_cluster.certificate_authority.0.data)
  token   = data.aws_eks_cluster_auth.my_cluster.token
  load_config_file       = false
}
