

output "ec2_instance_id" {
  value = aws_instance.my_eks_instance.id
}


output "ecr_repository_url" {
  value = aws_ecr_repository.sudoku_solver_app1.repository_url
}

# Define other resources and configurations as needed..

