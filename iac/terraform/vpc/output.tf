output "ec2_instance_id" {
  value = aws_instance.my_eks_instance.id
}

output "kubeconfig" {
  value = data.aws_eks_cluster_auth.my_cluster.kubeconfig
}

output "ecr_repository_url" {
  value = aws_ecr_repository.my_repository.repository_url
}

output "eks_cluster_endpoint" {
  value = module.eks_cluster.cluster_endpoint
}

output "eks_cluster_ca_data" {
  value = module.eks_cluster.cluster_certificate_authority_data
}


# Define other resources and configurations as needed..

