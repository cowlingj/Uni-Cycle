output "kubeconfig_filename" {
  depends_on = [
    null_resource.wait_for_cluster,
    kubernetes_config_map.aws_auth,
    helm_release.autoscaler
  ]
  value = local_file.kubeconfig.filename
}

output host {
  depends_on = [
    null_resource.wait_for_cluster,
    kubernetes_config_map.aws_auth
  ]
  value = aws_eks_cluster.primary.endpoint
}

output certificate_authority_data {
  value = aws_eks_cluster.primary.certificate_authority.0.data
}

output token {
  value = data.aws_eks_cluster_auth.primary.token
}

