output "ecr_repository_url" {
  value = aws_ecr_repository.sudoku_solver.repository_url
}

# Output the EKS cluster endpoint
output "eks_cluster_endpoint" {
  value = module.eks_cluster.cluster_endpoint
}

# Output the EKS cluster certificate authority data
output "eks_cluster_ca_data" {
  value = module.eks_cluster.cluster_certificate_authority_data
}

# Define other resources and configurations as needed..

