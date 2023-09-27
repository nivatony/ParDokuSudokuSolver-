output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.my_cluster.certificate_authority[0].data

}

output "cluster_endpoint" {
  value = aws_eks_cluster.my_cluster.endpoint
}

output "cluster_id" {
  value = aws_eks_cluster.my_cluster.id
}

output "ecr_repository_url" {
  value = aws_ecr_repository.sudoku_solver_app1.repository_url
}

# Define other resources and configurations as needed..

