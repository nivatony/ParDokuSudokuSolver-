

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

# Define your EKS cluster resource (assuming you have it defined).
resource "aws_eks_cluster" "my_cluster" {
  name     = var.cluster_name
  role_arn = "arn:aws:iam::712699700534:role/github-actions-role"
  # Other configurations...
}

# Rest of your EKS configurations...
