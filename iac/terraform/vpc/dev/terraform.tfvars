cluster_name = "awesome_cluster"

desired_size = 1
max_size     = 1
min_size     = 1



# Service Account Variables
#worker_nodes_sa_name = "my-worker-nodes"
#worker_nodes_sa_namespace = "kube-system"

# Cluster Role Variables
read_only_pods_role_name = "my-read-only-pods"

# Cluster Role Binding Variables
worker_nodes_read_pods_binding_name = "my-worker-nodes-read-pods"

#kubeconfig = ".kube_config.yaml"

environment = "dev"

vpc_cidr_block = "10.0.0.0/16"

public_subnet_1_details = {
  availability_zone = "eu-north-1a"
  cidr_block        = "10.0.1.0/24"
}

public_subnet_2_details = {
  availability_zone = "eu-north-1b"
  cidr_block        = "10.0.2.0/24"
}

private_subnet_1_details = {
  availability_zone = "eu-north-1c"
  cidr_block        = "10.0.3.0/24"
}

private_subnet_2_details = {
  availability_zone = "eu-north-1c"
  cidr_block        = "10.0.4.0/24"
}

alb_name = "awesome_cluster_alb1"
key_pair = "MyKeyPair"
instance_types = "t3.small"



node_group_name = "my-node-group"
eks_node_group_role_name = "node_group_role_niva"
eks_worker_node_policy_arn = "worker_node_policy_arn_niva"
eks_cni_policy_arn = "cni_policy_arn_niva"
ec2container_policy_arn = "c2container_policy_arn_niva"
eks_vpc_resource_controller_policy_arn = "vpc_resource_controller_policy_arn_niva"

