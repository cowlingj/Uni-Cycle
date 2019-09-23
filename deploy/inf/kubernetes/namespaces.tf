resource "kubernetes_namespace" "main" {
  metadata {
    labels = {
      istio-injection = "enabled"
    }
    generate_name = "main-"
  }
}

resource "kubernetes_namespace" "helm" {
  metadata {
    generate_name = "helm-"
  }
}

resource "kubernetes_namespace" "istio" {
  metadata {
    generate_name = "istio-"
  }
}