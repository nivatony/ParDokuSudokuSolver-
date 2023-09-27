provider "aws" {
  region = "eu-north-1"  # Change to your desired AWS region....
}

# Define your VPC and Subnets
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

# Declare your subnets
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_1_details.cidr_block
  availability_zone       = var.public_subnet_1_details.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name                                        = "${var.cluster_name}-${var.environment}-public-subnet-${substr(var.public_subnet_1_details.availability_zone, -2, -1)}"
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "ClusterName"                               = var.cluster_name
    "Environment"                               = var.environment
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_2_details.cidr_block
  availability_zone       = var.public_subnet_2_details.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name                                        = "${var.cluster_name}-${var.environment}-public-subnet-${substr(var.public_subnet_2_details.availability_zone, -2, -1)}"
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "ClusterName"                               = var.cluster_name
    "Environment"                               = var.environment
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_1_details.cidr_block
  availability_zone       = var.private_subnet_1_details.availability_zone
  map_public_ip_on_launch = false
  tags = {
    Name                                        = "${var.cluster_name}-${var.environment}-private-subnet-${substr(var.private_subnet_1_details.availability_zone, -2, -1)}"
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_2_details.cidr_block
  availability_zone       = var.private_subnet_2_details.availability_zone
  map_public_ip_on_launch = false
  tags = {
    Name                                        = "${var.cluster_name}-${var.environment}-private-subnet-${substr(var.private_subnet_2_details.availability_zone, -2, -1)}"
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}



 resource "aws_internet_gateway" "internet_gw" {
  vpc_id = aws_vpc.main.id

  tags = {
        "Name"        = "${var.cluster_name}-${var.environment}-internet-gateway"
        "ClusterName" = var.cluster_name
        "Environment" = var.environment
  }
}

data "aws_availability_zones" "available" {
}





# Module for cluster autoscaler IAM role for Service Accounts in EKS
#module "cluster_autoscaler_irsa_role" {
  #source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  #version = "5.3.1"

  #role_name                        = "cluster-autoscaler"
  ##attach_cluster_autoscaler_policy = true
  #cluster_autoscaler_cluster_ids   = [module.var.cluster_name_id]

  #oidc_providers = {
   # ex = {
      #namespace_service_accounts = ["kube-system:cluster-autoscaler"]
     # provider_arn               = var.cluster_name.oidc_provider_arn
   #   namespace_service_accounts = ["kube-system:cluster-autoscaler"]
   # }
  #}
#}

# Create EKS Cluster (integrated with your VPC and subnets)
resource "aws_eks_cluster" "my_cluster" {
  name     = var.cluster_name
  role_arn = "arn:aws:iam::712699700534:role/github-actions-role"
  vpc_config {
    subnet_ids = [
      aws_subnet.public_subnet_1.id,
      aws_subnet.public_subnet_2.id,
      aws_subnet.private_subnet_1.id,
      aws_subnet.private_subnet_2.id,
    ]
    endpoint_public_access  = var.endpoint_public_access
    endpoint_private_access = var.endpoint_private_access
    public_access_cidrs     = var.public_access_cidrs
    security_group_ids      = [aws_security_group.node_group_one.id]
  }


resource "aws_eks_node_group" "nodegroup" {
  cluster_name    = aws_eks_cluster.my_cluster.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.cloudquicklabs2.arn
  subnet_ids      = var.aws_public_subnet
  instance_types  = var.instance_types

  remote_access {
    source_security_group_ids = [aws_security_group.node_group_one.id]
    ec2_ssh_key               = var.key_pair
  }

  scaling_config {
    desired_size = var.scaling_desired_size
    max_size     = var.scaling_max_size
    min_size     = var.scaling_min_size
  }


resource "aws_security_group" "node_group_one" {
  name_prefix = "node_group_one"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "niva1" {
  name = "eks-cluster-niva"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "niva-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::712699700534:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.niva1.name
}

# Optionally, enable Security Groups for Pods
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "niva-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam:712699700534:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.niva1.name
}

resource "aws_iam_role" "niva" {
  name = "eks-node-group-cloudquicklabs"

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

resource "aws_iam_role_policy_attachment" "niva-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::712699700534:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.niva.name
}

resource "aws_iam_role_policy_attachment" "niva-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::712699700534:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.niva.name
}

resource "aws_iam_role_policy_attachment" "niva-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::712699700534:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.niva.name
}

}


resource "aws_ecr_repository" "sudoku_solver_app1" {
  name = "sudoku_solver_app1"
}
}

