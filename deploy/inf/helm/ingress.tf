resource "helm_release" "gateway" {

  depends_on = [ var._depends_on, helm_release.istio ]

  name       = "gateway"
  chart      = "${path.root}/../charts/gateway"
  version    = "0.0.1"
  namespace  = var.namespaces.istio

  set {
    name = "cms.host"
    value = "cms.${var.namespaces.main}.svc.cluster.local"
  }

  set {
    name = "cms.graphql.host"
    value = "cms.${var.namespaces.main}.svc.cluster.local"
  }

  set {
    name = "store.host"
    value = "store.${var.namespaces.main}.svc.cluster.local"
  }

  set {
    name = "certIssuer"
    value = "letsencrypt-staging" # TODO: use prod
  }

  set {
    name = "domainName"
    value = ""
  }

  set {
    name = "useHttps"
    value = false
  }
}