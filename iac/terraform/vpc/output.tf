data "aws_eks_cluster" "my_cluster" {
  name = var.cluster_name
}

output "ec2_instance_id" {
  value = aws_instance.my_eks_instance.id
}

output "kubeconfig" {
  value = data.aws_eks_cluster_auth.my_cluster.kubeconfig
}

data "template_file" "kubeconfig" {
  template = file("${path.module}/kubeconfig.tpl")

  vars = {
    eks_cluster_endpoint       = module.eks_cluster.cluster_endpoint
    eks_cluster_ca_data        = module.eks_cluster.cluster_certificate_authority_data
    cluster_name               = var.cluster_name
  }
}

output "kubeconfig" {
  value = data.template_file.kubeconfig.rendered
}


output "ecr_repository_url" {
  value = aws_ecr_repository.sudoku_solver_app1.repository_url
}

output "eks_cluster_ca_data" {
  value = data.aws_eks_cluster.my_cluster.certificate_authority[0].data
}
output "eks_cluster_endpoint" {
  value = data.aws_eks_cluster.my_cluster.endpoint
}
# Define other resources and configurations as needed..

