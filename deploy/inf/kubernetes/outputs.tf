output "service_account_name" {
  depends_on = [ kubernetes_cluster_role_binding.helm_role_binding ]
  value = kubernetes_service_account.helm.metadata[0].name
}

output "namespaces" {
  value = {
    main = kubernetes_namespace.main.metadata[0].name
    helm = kubernetes_namespace.helm.metadata[0].name
    istio = kubernetes_namespace.istio.metadata[0].name
  }
}
