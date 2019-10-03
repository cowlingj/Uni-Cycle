resource "helm_release" "store" {
  depends_on = [ helm_release.istio ]

  name       = "store"
  chart      = "${path.root}/../../store/charts/store/"
  version    = "0.0.1"
  namespace  = var.namespaces.main

  set {
    name = "cms.cms.db"
    value = "cms"
  }

  set {
    name = "cms.svc.api.namespace"
    value = var.namespaces.main
  }

  set {
    name = "cms.mongodb.version"
    value = "0.0.1"
  }

  set {
    name = "cms.mongodb.port"
    value = "8080"
  }

  set {
    name = "cms.cms.mongodbUrl"
    value = "mongodb://cms:cms@mongodb.${var.namespaces.main}.svc.cluster.local:8080/cms"
  }
}