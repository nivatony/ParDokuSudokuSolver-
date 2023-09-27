resource "aws_iam_role" "eks_node_group" {
  name = var.eks_node_group_role_name

  # Attach policies here, or you can attach them later in your root module
}

# Attach the AmazonEKSWorkerNodePolicy
resource "aws_iam_role_policy_attachment" "eksworkernode_policy" {
  policy_arn = var.eks_worker_node_policy_arn
  role       = aws_iam_role.eks_node_group.name
}

# Attach the AmazonEKS_CNI_Policy
resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = var.eks_cni_policy_arn
  role       = aws_iam_role.eks_node_group.name
}

# Attach the AmazonEC2ContainerRegistryReadOnly
resource "aws_iam_role_policy_attachment" "ec2container_policy" {
  policy_arn = var.ec2container_policy_arn
  role       = aws_iam_role.eks_node_group.name
}

# Attach the AmazonEKSVPCResourceController
resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  policy_arn = var.eks_vpc_resource_controller_policy_arn
  role       = aws_iam_role.eks_node_group.name
}
