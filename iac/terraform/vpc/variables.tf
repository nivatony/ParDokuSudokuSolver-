variable "cluster_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "public_subnet_1_details" {
  type = object({
    availability_zone = string
    cidr_block        = string
  })
}

variable "public_subnet_2_details" {
  type = object({
    availability_zone = string
    cidr_block        = string
  })
}

variable "private_subnet_1_details" {
  type = object({
    availability_zone = string
    cidr_block        = string
  })
}

variable "private_subnet_2_details" {
  type = object({
    availability_zone = string
    cidr_block        = string
  })
}

variable "eks_node_group_role_name" {
  description = "The name of the IAM role for the EKS node group."
}

variable "eks_worker_node_policy_arn" {
  description = "The ARN of the AmazonEKSWorkerNodePolicy."
}

variable "eks_cni_policy_arn" {
  description = "The ARN of the AmazonEKS_CNI_Policy."
}

variable "ec2container_policy_arn" {
  description = "The ARN of the AmazonEC2ContainerRegistryReadOnly."
}

variable "eks_vpc_resource_controller_policy_arn" {
  description = "The ARN of the AmazonEKSVPCResourceController."
}


