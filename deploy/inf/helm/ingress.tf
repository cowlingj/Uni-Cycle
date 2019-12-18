resource "helm_release" "gateway" {

  depends_on = [ var._depends_on, helm_release.ingress_controller ]

  name       = "gateway"
  chart      = "${path.root}/../charts/gateway"
  version    = "0.0.1"
  namespace  = var.use_istio ? var.namespaces.istio : var.namespaces.main

  set {
    name = "cms.host"
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

  set {
    name = "useIstio"
    value = var.use_istio
  }
}

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
}
