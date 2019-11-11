resource "kubernetes_service_account" "helm" {
  metadata {
    generate_name = "helm-"
    namespace = kubernetes_namespace.helm.metadata[0].name
  }
}

# resource "kubernetes_cluster_role" "example" {
#   metadata {
#     name = "terraform-example"
#   }

#   rule {
#     api_groups = [""]
#     resources  = ["namespaces", "pods"]
#     verbs      = ["get", "list", "watch"]
#   }
# }

resource "kubernetes_cluster_role_binding" "helm_role_binding" {
  metadata {
    name = "helm-crb"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.helm.metadata[0].name
    namespace = kubernetes_namespace.helm.metadata[0].name
  }
}