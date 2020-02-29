locals {
  use_istio = jsondecode(file("${path.root}/config/cluster/${var.cluster}/cluster.json")).use_istio
}

resource "kubernetes_namespace" "main" {

  timeouts {
    delete = "10m"
  }

  metadata {
    labels = {
      istio-injection = "enabled"
    }
    generate_name = "main-"
  }
}

resource "kubernetes_namespace" "helm" {

  timeouts {
    delete = "10m"
  }

  metadata {
    generate_name = "helm-"
  }
}

resource "kubernetes_namespace" "istio" {

  count = local.use_istio ? 1 : 0

  timeouts {
    delete = "10m"
  }

  metadata {
    generate_name = "istio-"
  }
}
