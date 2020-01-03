output "kubernetes_config" {
  depends_on = [
    null_resource.catch_all
  ]
  value = var.cluster == "google" ? module.google.kubernetes_config : module.minikube.kubernetes_config
}

output "lb_ip_address" {
  value = var.cluster == "google" ? module.google.lb_ip_address : module.minikube.lb_ip_address
}
