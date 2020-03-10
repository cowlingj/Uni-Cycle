resource "helm_release" "store" {

  depends_on = [ var._depends_on ]

  name       = "store"
  chart      = "${path.root}/../../store/charts/store/"
  version    = "0.0.1"
  namespace  = var.namespaces.main

  set {
    name = "imagePullSecres"
    value = jsonencode(local.image_pull_secrets)
  }

  set {
    name = "resources.internal.path"
    value = "/cms/graphql"
  }

  set {
    name = "resources.external.path"
    value = "/cms/graphql"
  }

  dynamic set {
    for_each = var.lb_ip_address.address != null ? [ null ] : []
    content {
      name = "backend.ip"
      value = var.lb_ip_address.address
    }
  }

  set {
    name = "email"
    value = jsondecode(file("${path.root}/config/store/contact.json")).contact_email
  }
}
