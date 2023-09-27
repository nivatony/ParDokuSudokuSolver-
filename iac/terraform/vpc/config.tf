

resource "null_resource" "configure_kubectl" {
  # This triggers the resource whenever the EKS cluster is created or updated.
  triggers = {
    eks_cluster_id = aws_eks_cluster.my_cluster.id
  }

  # Use the local-exec provisioner to run the AWS CLI command to configure kubectl.
  provisioner "local-exec" {
    command = <<-EOT
      aws eks update-kubeconfig --name ${aws_eks_cluster.my_cluster.name}
    EOT

    # Specify the working directory if needed.
    working_dir = path.module
  }
}

# Rest of your EKS configuration
