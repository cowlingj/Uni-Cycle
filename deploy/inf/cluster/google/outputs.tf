output "kubernetes_config" {

  depends_on = [
    null_resource.wait.id
  ]

  value = {
    load_config_file = var.enabled ? false : null
    config_path = null
    config_context = null
    config_context_cluster = null
    config_context_auth_info = null

    host = var.enabled ? google_container_cluster.main.0.endpoint : null
    username = var.enabled ? google_container_cluster.main.0.master_auth.0.username : null
    password = var.enabled ? google_container_cluster.main.0.master_auth.0.password : null
    client_certificate = var.enabled ? base64decode(google_container_cluster.main.0.master_auth.0.client_certificate) : null
    client_key = var.enabled ? base64decode(google_container_cluster.main.0.master_auth.0.client_key) : null
    cluster_ca_certificate = var.enabled ? base64decode(google_container_cluster.main.0.master_auth.0.cluster_ca_certificate) : null
    insecure = var.enabled ? false : null
    
    token = null
    exec = null
  }
}