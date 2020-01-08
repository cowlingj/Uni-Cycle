resource "helm_release" "store" {

  depends_on = [ var._depends_on ]

  name       = "store"
  chart      = "${path.root}/../../store/charts/store/"
  version    = "0.0.1"
  namespace  = var.namespaces.main

  dynamic set {
    for_each = length(var.image_pull_secret_names) > 0 ? slice(var.image_pull_secret_names, 0, 1) : []
    iterator = each
    content {
      name = "imagePullSecret"
      value = each.value
    }
  }

  dynamic set {
    for_each = var.lb_ip_address.address != null ? [ null ] : []
    content {
      name = "backend.ip"
      value = var.lb_ip_address.address
    }
  }
}
