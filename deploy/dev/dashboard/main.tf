resource "kubernetes_secret" "dashboard_csrf" {
  metadata {
    name      = "kubernetes-dashboard-csrf"
    namespace = "kube-system"
  }
  type = "Opaque"
  data = {
    csrf = ""
  }
}

resource "helm_release" "dashboard" {
  name       = "dashboard"
  chart      = "kubernetes-dashboard"
  namespace  = "kube-system"
  repository = "https://kubernetes-charts.storage.googleapis.com"

  set {
    name  = "image.repository"
    value = "kubernetesui/dashboard"
  }

  set {
    name  = "image.tag"
    value = "v2.0.0"
  }

  set {
    name  = "enableInsecureLogin"
    value = true
  }

  set {
    name  = "enableSkipLogin"
    value = true
  }

  set {
    name  = "rbac.clusterAdminRole"
    value = true
  }

  set {
    name  = "fullnameOverride"
    value = "kubernetes-dashboard"
  }
}