resource "helm_release" "ingress_controller" {
  name       = "ingress"
  chart      = "nginx-ingress"
  namespace  = "default"
  repository = "https://kubernetes-charts.storage.googleapis.com"

  set {
    name  = "controller.publishService.enabled"
    value = true
  }

  set {
    name  = "rbac.create"
    value = true
  }

  set {
    name  = "controller.service.type"
    value = "NodePort"
  }

  set {
    name  = "controller.service.nodePorts.http"
    value = 30080
  }

  set {
    name  = "controller.service.nodePorts.https"
    value = 30443
  }
}
