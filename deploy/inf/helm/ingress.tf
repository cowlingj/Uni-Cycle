resource "helm_release" "gateway" {
  depends_on = [ helm_release.istio ]

  name       = "gateway"
  chart      = "${path.root}/../charts/gateway"
  version    = "0.0.1"
  namespace  = var.namespaces.main

  set {
    name = "cms.host"
    value = "cms.${var.namespaces.main}.svc.cluster.local"
  }

  set {
    name = "store.host"
    value = "store.${var.namespaces.main}.svc.cluster.local"
  }
}