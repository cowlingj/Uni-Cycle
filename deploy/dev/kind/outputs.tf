output host {
  depends_on = [
    null_resource.kind_cluster.id
  ]
  value = yamldecode(data.local_file.kubeconfig.content).clusters[0].cluster.server
}

output ca_data {
  depends_on = [
    null_resource.kind_cluster.id
  ]
  value = yamldecode(data.local_file.kubeconfig.content).clusters[0].cluster.certificate-authority-data
}

output kubeconfig_location {
  depends_on = [
    null_resource.kind_cluster
  ]
  value = local.kubeconfig_location
}