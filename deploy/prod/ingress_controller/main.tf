resource "helm_release" "ingress_controller" {
  name       = "ingress"
  chart      = "nginx-ingress"
  namespace  = "default"
  repository = "https://kubernetes-charts.storage.googleapis.com"

  set {
    name = "controller.publishService.enabled"
    value = true
  }

  set {
    name = "rbac.create"
    value = true
  }

  dynamic "set" {
    for_each = var.ingress_ip_address != null ? [null] : []
    content {
      name = "controller.service.loadBalancerIP"
      value = var.ingress_ip_address
    }
  }

  set {
    name = "fullnameOverride"
    value = "ingress-nginx-ingress"

  }

  set {
    name = "controller.name"
    value = "controller"
  }

  # set {
  #   name = "controller.service.loadBalancerIP"
  #   value = var.ingress_ip_address
  # }
  # controller.service.type=NodePort
}

data "kubernetes_service" "ingress_controller" {
  depends_on = [helm_release.ingress_controller]
  metadata {
    name = "ingress-nginx-ingress-controller"
  }
}
