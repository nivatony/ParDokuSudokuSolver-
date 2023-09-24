provider "aws" {
 
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

resource "aws_ssm_parameter" "eks_cluster_vpc_info" {
  depends_on = [aws_vpc.main, aws_subnet.public_subnet_1, aws_subnet.public_subnet_2, aws_subnet.private_subnet_1, aws_subnet.private_subnet_2]
  name       = "/eks/${var.cluster_name}/${var.environment}/vpc"
  type       = "String"
  value = jsonencode({
    "vpc_id"              = aws_vpc.main.id
    "public_subnet_1_id"  = aws_subnet.public_subnet_1.id
    "public_subnet_2_id"  = aws_subnet.public_subnet_2.id
    "private_subnet_1_id" = aws_subnet.private_subnet_1.id
    "private_subnet_2_id" = aws_subnet.private_subnet_2.id
  })
}

resource "aws_ecr_repository" "sudoku_solver" {
  name = "sudoku_solver_app"
}

module "eks_cluster" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = "1.21"  # Replace with your desired Kubernetes version
  subnets         = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
  vpc_id          = aws_vpc.main.id
}

module "eks_node_group" {
  source           = "terraform-aws-modules/eks/aws//modules/node_group"
  cluster_name     = module.eks_cluster.cluster_id
  cluster_endpoint = module.eks_cluster.cluster_endpoint
  node_group_name  = "eks-node-group"
  node_instance_type = "t2.micro"
  node_subnet_ids  = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
  node_group_desired_capacity = 2
  node_group_min_size = 1
  node_group_max_size = 3
 # key_name         = "ssh-key-pair"  aws ec2 create-key-pair --key-name my-key-pair --query 'KeyMaterial' --output text > my-key-pair.pem

  node_security_group_ids = [aws_security_group.node_security_group.id]
}

