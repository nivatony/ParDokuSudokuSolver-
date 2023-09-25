provider "aws" {
  region = "eu-north-1"  # Change to your desired AWS region
}


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

data "aws_availability_zones" "available" {
  state = "available"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.29.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.27"  # Replace with your desired Kubernetes version

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  vpc_id     = aws_vpc.main.id
  subnet_ids = concat(aws_subnet.public_subnet_1[*].id, aws_subnet.public_subnet_2[*].id)  # Use public subnets

  enable_irsa = true

  eks_managed_node_group_defaults = {
    disk_size = 50
  }

  eks_managed_node_groups = {
    general = {
      desired_size = 1
      min_size     = 1
      max_size     = 10

      labels = {
        role = "general"
      }

      instance_types = ["t3.small"]
      capacity_type  = "ON_DEMAND"
    }

    spot = {
      desired_size = 1
      min_size     = 1
      max_size     = 10

      labels = {
        role = "spot"
      }

      taints = [{
        key    = "market"
        value  = "spot"
        effect = "NO_SCHEDULE"
      }]

      instance_types = ["t3.micro"]
      capacity_type  = "SPOT"
    }
  }

  tags = {
    Environment = "dev"
  }
}
