provider "aws" {
 region = "eu-north-1"  # Change to your desired AWS region....
}
#
#...
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
    
  }
}

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


# Create a ClusterRole that grants read-only access to Pods
resource "kubernetes_cluster_role" "read_only_pods" {
  metadata {
    name = var.read_only_pods_role_name
  }

  rule {
    api_groups = [""]
    resources  = ["pods"]
    verbs      = ["get", "list", "watch"]
  }
}


# Create a ClusterRoleBinding to bind the ClusterRole to the ServiceAccount
resource "kubernetes_cluster_role_binding" "worker_nodes_read_pods" {
  metadata {
    name = var.worker_nodes_read_pods_binding_name
  }

  role_ref {
    kind     = "ClusterRole"
    name     = kubernetes_cluster_role.read_only_pods.metadata[0].name
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.worker_nodes.metadata[0].name
    namespace = kubernetes_service_account.worker_nodes.metadata[0].namespace
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


