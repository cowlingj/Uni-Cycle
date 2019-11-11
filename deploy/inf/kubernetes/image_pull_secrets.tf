resource "kubernetes_secret" "image_pull_secrets" {

  count = length(var.image_pull_secrets)

  metadata {
    name = "secret-regcred-${count.index}"
    namespace = kubernetes_namespace.main.metadata[0].name
  }

  type = "kubernetes.io/dockerconfigjson"

  data  = {
    ".dockerconfigjson" = templatefile("${path.module}/dockerconfig.template.json", {
      registry = var.image_pull_secrets[count.index].registry
      auth = base64encode("${var.image_pull_secrets[count.index].username}:${var.image_pull_secrets[count.index].password}")
    })
  }
}