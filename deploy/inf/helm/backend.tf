resource "random_password" "cms_db_password" {
  length = 32
  special = false
  keepers = {
    storage_id = var.pvc_name
  }
}

resource "random_password" "root_db_password" {
  length = 32
  special = false
  keepers = {
    storage_id = var.pvc_name
  }
}

variable "cms_db_username" {
  type = string
  default = "cms"
}

variable "cms_db_database" {
  type = string
  default = "cms"
}

locals {
  izettle_credentials = jsondecode(file("${path.root}/.secrets/credentials/izettle.json"))
  users = jsondecode(file("${path.root}/.secrets/cms/default-users.json")).users
  string_values = jsondecode(file("${path.root}/.secrets/cms/default-strings.json")).strings
}

resource "helm_release" "backend" {

  depends_on = [ var._depends_on ]

  timeout = 900

  name       = "ecommerce-backend"
  repository = data.helm_repository.github_master.name
  chart      = "ecommerce-backend"
  version    = "0.0.1"
  namespace  = var.namespaces.main

  dynamic set {
    for_each = length(var.image_pull_secret_names) > 0 ? slice(var.image_pull_secret_names, 0, 1) : []
    iterator = each
    content {
      name = "cms.imagePullSecret"
      value = each.value
    }
  }

  dynamic set {
    for_each = length(var.image_pull_secret_names) > 0 ? slice(var.image_pull_secret_names, 0, 1) : []
    iterator = each
    content {
      name = "izettle-products.imagePullSecret"
      value = each.value
    }
  }

  dynamic set {
    for_each = var.image_pull_secret_names
    iterator = each
    content {
      name = "mongodb.image.pullSecrets[${each.key}]"
      value = each.value
    }
  }

  set {
    name = "mongodb.persistence.existingClaim"
    value = var.pvc_name
  }

  set {
    name = "mongodb.readinessProbe.enabled"
    value = false
  }

  set {
    name = "mongodb.livenessProbe.enabled"
    value = false
  }

  # TODO: check things still work without this
  set {
    name = "mongodb.volumePermissions.enabled"
    value = var.cluster == "google"
  }

  set_string {
    name = "mongodb.podAnnotations.readiness\\.status\\.sidecar\\.istio\\.io/initialDelaySeconds"
    value = "900"
  }

  set_sensitive {
    name = "mongodb-config.rootPassword"
    value = random_password.root_db_password.result
  }

  set {
    name = "izettle-products.izettleCredentials.username"
    value = local.izettle_credentials.username
  }

  set_sensitive {
    name = "izettle-products.izettleCredentials.password"
    value = local.izettle_credentials.password
  }

  set {
    name = "izettle-products.izettleCredentials.client_id"
    value = local.izettle_credentials.client_id
  }

  set_sensitive {
    name = "izettle-products.izettleCredentials.client_secret"
    value = local.izettle_credentials.client_secret
  }

  set {
    name = "izettle-products.service.type"
    value = "NodePort"
  }

  set_sensitive { # TODO: integrate into backend (use anchor)
    name = "cms.mongodb.host"
    value = "mongodb.${var.namespaces.main}.svc.cluster.local"
  }

  dynamic set_sensitive {
    for_each = local.users
    iterator = user
    content {
      name = "cms.users.data.users[${user.key}].username"
      value = user.value.username
    }
  }

  dynamic set_sensitive {
    for_each = local.users
    iterator = user
    content {
      name = "cms.users.data.users[${user.key}].password"
      value = user.value.password
    }
  }

  dynamic set_sensitive {
    for_each = local.users
    iterator = user
    content {
      name = "cms.users.data.users[${user.key}].isAdmin"
      value = user.value.is_admin
    }
  }

  dynamic set_string {
    for_each = local.string_values
    iterator = string_value
    content {
      name = "cms.strings.data.strings[${string_value.key}].key"
      value = string_value.value.key
    }
  }

  dynamic set_string {
    for_each = local.string_values
    iterator = string_value
    content {
      name = "cms.strings.data.strings[${string_value.key}].value"
      value = replace(replace(string_value.value.value, "/\n/", "\n"), ",", "\\,")
    }
  }

  set {
    name = "cms.mongodb.cms.password"
    value = random_password.cms_db_password.result
  }

  set {
    name = "cms.service.type"
    value = "NodePort"
  }

  set {
    name = "nginx-ingress.cms.host"
    value = "cms.${var.namespaces.main}.svc.cluster.local"
  }

  set {
    name = "nginx-ingress.store.host"
    value = "store.${var.namespaces.main}.svc.cluster.local"
  }

  set {
    name = "nginx-ingress.certIssuer"
    value = "letsencrypt-staging" # TODO: use prod
  }

  set {
    name = "nginx-ingress.domainName"
    value = ""
  }

  set {
    name = "nginx-ingress.useHttps"
    value = false
  }
}
