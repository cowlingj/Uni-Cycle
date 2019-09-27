resource "helm_release" "store" {
  depends_on = [ helm_release.istio ]

  name       = "store"
  chart      = "${path.root}/../../helm/repo/store-0.0.1.tgz"
  version    = "0.0.1"
  namespace  = var.namespaces.main

  set {
    name = "cms.url"
    value = "store.${var.namespaces.main}.svc.cluster.local"
  }
}