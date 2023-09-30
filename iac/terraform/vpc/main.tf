provider "aws" {
 region = "eu-north-1"  # Change to your desired AWS region....
}
#
#..
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








# Create EKS Cluster (integrated with your VPC and subnets)
resource "aws_eks_cluster" "my_cluster" {
  name     = var.cluster_name
  role_arn = "arn:aws:iam::712699700534:role/github-actions-role"
  vpc_config {

    endpoint_public_access= true
    subnet_ids = [
      aws_subnet.public_subnet_1.id,
      aws_subnet.public_subnet_2.id,
      aws_subnet.private_subnet_1.id,
      aws_subnet.private_subnet_2.id,
    ]
    
  } 
   
}

# Data block to fetch information about the EKS cluster
data "aws_eks_cluster" "my_cluster" {
  name = "awesome_cluster"
}

#resource "local_file" "kubeconfig" {
  #content  = file("kube_config.yaml")
  #filename = ".kube_config.yaml"
#}


resource "aws_lb_target_group" "my_tg" {
  name     = "my-tg"
  target_type = "instance"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}


resource "aws_security_group" "node_group_one" {
  name_prefix = "node_group_one"
  vpc_id                  = aws_vpc.main.id

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



# Create a ServiceAccount for the worker nodes
resource "kubernetes_service_account" "worker_nodes" {
  metadata {
    name      = var.worker_nodes_sa_name
    namespace = var.worker_nodes_sa_namespace
  }
}





resource "aws_iam_role" "niva1" {
  name = "awsome_cluster"

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




resource "aws_ecr_repository" "sudoku_solver_app1" {
  name = "sudoku_solver_app1"
}


