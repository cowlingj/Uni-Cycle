output "token" {
  value = data.google_client_config.provider.access_token
  depends_on = [
    null_resource.wait.id
  ]  
}

output "cluster_ca_certificate" {
  value = google_container_cluster.main.master_auth[0].cluster_ca_certificate
  depends_on = [
    null_resource.wait.id
  ]
}

output "host" {
  value = google_container_cluster.main.endpoint
  depends_on = [
    null_resource.wait.id
  ]
}


output "loadbalancer_ip_address" {
  value = {
    address: google_compute_address.ip_address.address
    name: google_compute_address.ip_address.name
  }
}