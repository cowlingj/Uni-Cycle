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

  timeouts {
    delete = "10m"
  }

  metadata {
    generate_name = "istio-"
  }
}