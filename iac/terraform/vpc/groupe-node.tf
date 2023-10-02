# Resource: aws_eks_node_group
resource "aws_eks_node_group" "my-node-group" {
  cluster_name = aws_eks_cluster.my_cluster.name
  node_group_name = "my-node-group"
  node_role_arn = "arn:aws:iam::712699700534:role/github-actions-role"
  subnet_ids = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id
  ]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1 
  }

  ami_type       = "AL2_x86_64"
  capacity_type  = "ON_DEMAND"
  disk_size      = 20 
  instance_types = ["t3.small"]
   
}     
    
resource "aws_iam_policy" "additional_ecr_access" {
  name        = "ecr-read-access"
  description = "Allow ECR access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      { 
        "Effect" : "Allow",
        "Resource" : "*",
        "Action" : [
          "ecr:GetRegistryPolicy",
          "ecr:DescribeImageScanFindings",
          "ecr:GetLifecyclePolicyPreview",
          "ecr:GetDownloadUrlForLayer",
          "ecr:DescribeRegistry",
          "ecr:DescribePullThroughCacheRules",
          "ecr:DescribeImageReplicationStatus",
          "ecr:GetAuthorizationToken",
          "ecr:ListTagsForResource",
          "ecr:ListImages",
          "ecr:BatchGetRepositoryScanningConfiguration",
          "ecr:GetRegistryScanningConfiguration",
          "ecr:GetAuthorizationToken*",
          "ecr:UntagResource",
          "ecr:BatchGetImage",
          "ecr:DescribeImages",
          "ecr:TagResource",
          "ecr:DescribeRepositories",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetRepositoryPolicy",
          "ecr:GetLifecyclePolicy"
        ]
      }
    ]
  })

  tags = local.common_tags
}
