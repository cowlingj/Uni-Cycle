locals {
  image_pull_secrets = jsondecode(file("${path.root}/config/kubernetes/${var.cluster}/image-pull-secrets.json")).image_pull_secrets
}

resource "kubernetes_secret" "image_pull_secrets" {

  count = length(local.image_pull_secrets)

  metadata {
    name = "secret-regcred-${count.index}"
    namespace = kubernetes_namespace.main.metadata[0].name
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = templatefile("${path.module}/dockerconfig.template.json", {
      registry = local.image_pull_secrets[count.index].registry
      auth = base64encode("${local.image_pull_secrets[count.index].username}:${
        local.image_pull_secrets[count.index].password != null
        ? local.image_pull_secrets[count.index].password
        : file("${path.root}/${local.image_pull_secrets[count.index].passwordFile}")
      }")
    })
  }
}
