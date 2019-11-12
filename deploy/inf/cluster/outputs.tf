output "kubernetes_config" {
  depends_on = [
    null_resource.catch_all
  ]
  value = var.cluster == "google" ? module.google.kubernetes_config : module.minikube.kubernetes_config
}