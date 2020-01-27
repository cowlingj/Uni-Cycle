resource "helm_release" "ingress_controller" {
  depends_on = [ var._depends_on ]

  count = var.use_istio ? 0 : 1

  name       = "ingress"
  chart      = "stable/nginx-ingress"
  namespace  = var.namespaces.main

  set {
    name = "controller.publishService.enabled"
    value = true
  }

  set {
    name = "rbac.create"
    value = true
  }

  set {
    name = "controller.service.loadBalancerIP"
    value = var.lb_ip_address.address != null ? var.lb_ip_address.address : "null"
  }
}
