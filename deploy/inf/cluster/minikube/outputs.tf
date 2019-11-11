output "kubernetes_config" {

  value = {
    load_config_file = var.enabled ? true : null
    config_path = null
    config_context = var.enabled ? "minikube" : null
    config_context_cluster = null
    config_context_auth_info = null

    host = null
    username = null
    password = null
    client_certificate = null
    client_key = null
    cluster_ca_certificate = null
    insecure = var.enabled ? false : null
    
    token = null
    exec = null
  }
}