resource "helm_release" "store" {
  depends_on = [ helm_release.istio ]

  name       = "store"
  chart      = "${path.root}/../charts/store"
  version    = "0.0.1"
  namespace  = var.namespaces.main

  set {
    name = "NUXT_ENV_CMS_URL"
    value = "store.${var.namespaces.main}.svc.cluster.local"
  }
}