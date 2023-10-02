variable "cluster_name" {
  type = string
}

variable "environment" {
  type = string
}


variable "public_route_table_id" {
  description = "ID of the public route table"
  type        = string
}

variable "private_route_table_id" {
  description = "ID of the private route table"
  type        = string
}


variable "desired_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 1
}

variable "min_size" {
  type    = number
  default = 1
}


#variable "kubeconfig" {
#}

#variable "kubeconfig_content" {
 # description = "Content for the kubeconfig file"
 # type        = string
#} 

variable "eks_worker_node_policy_arn" {
  description = "ARN of the Amazon EKS Worker Node Policy"
  type        = string
}

variable "eks_cni_policy_arn" {
  description = "ARN of the Amazon EKS CNI Policy"
  type        = string
}

variable "ec2_container_registry_policy_arn" {
  description = "ARN of the Amazon EC2 Container Registry ReadOnly Policy"
  type        = string
}

variable "iam_role_name" {
  description = "Name of the IAM Role"
  type        = string
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


variable "my_alb" {
  description = "Reference to the ALB resource"
  type        = object({
    arn          = string
    dns_name     = string
    id           = string
    load_balancer_type = string
    zone_id      = string
  })
  default     = null
}





