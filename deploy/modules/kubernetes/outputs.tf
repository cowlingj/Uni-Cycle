output "service_account_name" {
  value = kubernetes_service_account.helm.metadata[0].name
  depends_on = [
    kubernetes_cluster_role_binding.helm_role_binding
  ]
}

output "helm_namespace" {
  value = kubernetes_namespace.helm.metadata[0].name
}

output "image_pull_secret_names" {
  value = values(kubernetes_secret.image_pull_secrets)[*].metadata[0].name
}
