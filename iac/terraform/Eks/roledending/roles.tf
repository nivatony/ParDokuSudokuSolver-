# terraform/eks/roles.tf

resource "kubernetes_cluster_role_binding" "eks_admin_binding" {
  metadata {
    name = "eks-admin-binding"
  }

  subject {
    kind      = "User"
    name      = var.eks_admin_role_arn
    api_group = "rbac.authorization.k8s.io"
  }

  role_ref {
    kind      = "ClusterRole"
    name      = "cluster-admin"
    api_group = "rbac.authorization.k8s.io"
  }
}
