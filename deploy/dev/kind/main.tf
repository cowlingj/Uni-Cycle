locals {
  kubeconfig_location = "${path.root}/generated/kind/kubeconfig.yaml"
}

resource "null_resource" "kind_cluster" {

  triggers = {
    cluster_name        = var.cluster_name
    kubeconfig_location = local.kubeconfig_location
  }

  provisioner "local-exec" {
    environment = {
      KUBECONFIG = self.triggers.kubeconfig_location
    }
    command = <<EOF
    kind create cluster \
      --name "${self.triggers.cluster_name}" \
      --config="${path.module}/config.yaml" \
      --wait 2m
    EOF
    when    = create
  }

  provisioner "local-exec" {
    environment = {
      KUBECONFIG = self.triggers.kubeconfig_location
    }
    command = "kind delete cluster --name ${self.triggers.cluster_name}"
    when    = destroy
  }
}

data "local_file" "kubeconfig" {
  depends_on = [
    null_resource.kind_cluster
  ]

  filename = local.kubeconfig_location
}