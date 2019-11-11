resource "helm_release" "store" {

  depends_on = [ var._depends_on ]

  name       = "store"
  chart      = "${path.root}/../../store/charts/store/"
  version    = "0.0.1"
  namespace  = var.namespaces.main

  dynamic set {
    for_each = slice(var.image_pull_secret_names, 0, 0)
    iterator = each
    content {
      name = "imagePullSecret"
      value = each.value
    }
  }
}