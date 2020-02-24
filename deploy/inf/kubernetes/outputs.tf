output "service_account_name" {
  depends_on = [ kubernetes_cluster_role_binding.helm_role_binding ]
  value = kubernetes_service_account.helm.metadata[0].name
}

output "namespaces" {
  value = {
    main = kubernetes_namespace.main.metadata[0].name
    helm = kubernetes_namespace.helm.metadata[0].name
    istio = local.use_istio ? kubernetes_namespace.istio[0].metadata[0].name : null
  }
}

output "image_pull_secret_names" {
  value = kubernetes_secret.image_pull_secrets[*].metadata[0].name
}

output "pvc_name" {
  value = kubernetes_persistent_volume_claim.pvc.metadata[0].name
}
