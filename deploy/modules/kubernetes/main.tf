resource "kubernetes_secret" "image_pull_secrets" {

  for_each = fileset("${path.root}/secrets/kubernetes/image-pull-secrets/", "*.json")

  metadata {
    generate_name = "secret-regcred-"
    namespace     = "default"
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = file("${path.root}/secrets/kubernetes/image-pull-secrets/${each.key}")
  }
}

resource "kubernetes_namespace" "helm" {

  metadata {
    generate_name = "helm-"
  }
}

resource "kubernetes_service_account" "helm" {

  metadata {
    generate_name = "helm-"
    namespace     = kubernetes_namespace.helm.metadata[0].name
  }
}

resource "kubernetes_cluster_role_binding" "helm_role_binding" {

  metadata {
    name = "helm-crb"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.helm.metadata[0].name
    namespace = kubernetes_namespace.helm.metadata[0].name
  }
}
