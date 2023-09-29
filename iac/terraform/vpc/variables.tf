variable "cluster_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "kubeconfig" {
}


#variable "kubeconfig_content" {
 # description = "Content for the kubeconfig file"
 # type        = string
#}


variable "worker_nodes_read_pods_binding_name" {
  description = "Name of the Kubernetes ClusterRoleBinding binding ClusterRole to ServiceAccount"
  type        = string
  default     = "worker-nodes-read-pods"
}

variable "read_only_pods_role_name" {
  description = "Name of the Kubernetes ClusterRole granting read-only access to Pods"
  type        = string
  default     = "read-only-pods"
}



variable "worker_nodes_sa_name" {
  description = "Name of the Kubernetes ServiceAccount for worker nodes"
  type        = string
  default     = "worker-nodes"
}

variable "worker_nodes_sa_namespace" {
  description = "Namespace for the Kubernetes ServiceAccount for worker nodes"
  type        = string
  default     = "kube-system"
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



variable "node_group_name" {}

variable "scaling_desired_size" {}

variable "scaling_max_size" {}

variable "scaling_min_size" {}

variable "instance_types" {}

variable "key_pair" {}


