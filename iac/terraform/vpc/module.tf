module "eks" {
  source = "./"  # Use the correct path to your EKS module

  cluster_name = var.cluster_name
  region       = "eu-northt-1"  # Specify your desired region

  eks_node_group_role_name              = "my-eks-node-group-role"
  eks_worker_node_policy_arn           = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  eks_cni_policy_arn                   = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  ec2container_policy_arn              = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  eks_vpc_resource_controller_policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"

  # Other input variables specific to your module...
}
