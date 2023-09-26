provider "aws" {
  region = "eu-north-1"  # Change to your desired AWS region....

  #max_retries             = 5
 # timeout                 = "60m"  # Increase the timeout as needed
}


# Define your VPC and Subnets (from vpc.tf)
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    "Name"        = "${var.cluster_name}-${var.environment}-vpc"
    "ClusterName" = var.cluster_name
    "Environment" = var.environment
  }
}

# Define IAM roles, policies, and other resources as needed...

# IAM Role for EKS Node Group
resource "aws_iam_role" "eks_node_group" {
  name = "eks-node-group-${var.cluster_name}"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

# IAM Role Policy Attachments for EKS Node Group
resource "aws_iam_role_policy_attachment" "eksworkernode_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group.name
}

resource "aws_iam_role_policy_attachment" "ec2container_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_group.name
}

resource "aws_iam_role_policy_attachment" "eks_admin_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSAdminPolicy"
  role       = aws_iam_role.eks_node_group.name
}

# Create an EC2 Instance for EKS and other cluster configurations
resource "aws_instance" "my_eks_instance" {
  ami           = "ami-0703b5d7f7da98d1e"  # Specify your desired AMI
  instance_type = "t2.micro"     # Specify your desired instance type
  subnet_id     = aws_subnet.public_subnet_1.id  # Choose the appropriate subnet

  # Add other EC2 configuration as needed...

  # Tags for the EC2 instance
  tags = {
    Name = "EC2_eks_niva"  # Specify a name for your instance
  }
}

# Output the EC2 instance ID for future reference
output "ec2_instance_id" {
  value = aws_instance.EC2_eks_niva.id
}

# Create EKS Cluster (integrated with your VPC and subnets)
resource "aws_eks_cluster" "my_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_node_group.arn
  vpc_config {
    subnet_ids = [
      aws_subnet.public_subnet_1.id,
      aws_subnet.public_subnet_2.id,
      aws_subnet.private_subnet_1.id,
      aws_subnet.private_subnet_2.id,

    ]
  }

  # Other cluster configurations...
}

# Create EKS Node Group (integrated with your EKS cluster)
resource "aws_eks_node_group" "my_node_group" {
  cluster_name    = var.cluster_name
  node_group_name = "my-node-group"
  node_group_launch_template {
    launch_template_id = aws_launch_template.my_launch_template.id
    version            = aws_launch_template.my_launch_template.latest_version
  }

  # Other node group configurations...
}

# Generate kubeconfig for your EKS cluster
data "aws_eks_cluster_auth" "my_cluster" {
  name = aws_eks_cluster.var.cluster_name
}

output "kubeconfig" {
  value = data.aws_eks_cluster_auth.my_cluster.kubeconfig
}
