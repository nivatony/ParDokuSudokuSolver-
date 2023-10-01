# iac/terraform/Eks/roledending/outputs.tf

output "eks_assume_role_policy" {
  value = var.eks_assume_role_policy
}

output "eks_admin_role_arn" {
  value = var.eks_admin_role_arn
}

output "eks_admin_binding_name" {
  value = kubernetes_cluster_role_binding.eks_admin_binding.metadata[0].name
}
