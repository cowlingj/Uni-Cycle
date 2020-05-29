# generate kubeconfig file

resource local_file kubeconfig {
  content = templatefile("${path.module}/templates/kubeconfig.yaml", {
    cluster_name = var.cluster_name
    endpoint = aws_eks_cluster.primary.endpoint
    certificate_authority_data = aws_eks_cluster.primary.certificate_authority.0.data,
    region = data.aws_region.current.name
    credentials_file_location = var.aws_credentials_path
  })
  
  filename = "${path.root}/generated/kubeconfig"
}