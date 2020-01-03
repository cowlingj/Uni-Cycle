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
    value = jsondecode(file("${path.root}/.secrets/credentials/izettle.json")).username
  }

  set_sensitive {
    name = "izettle-products.izettleCredentials.password"
    value = jsondecode(file("${path.root}/.secrets/credentials/izettle.json")).password
  }

  set {
    name = "izettle-products.izettleCredentials.client_id"
    value = jsondecode(file("${path.root}/.secrets/credentials/izettle.json")).client_id
  }

  set_sensitive {
    name = "izettle-products.izettleCredentials.client_secret"
    value = jsondecode(file("${path.root}/.secrets/credentials/izettle.json")).client_secret
  }

  set_sensitive { # TODO: integrate into backend (use a host template flag)
    name = "cms.mongodb.host"
    value = "mongodb.${var.namespaces.main}.svc.cluster.local"
  }

  dynamic set_sensitive {
    for_each = var.users
    iterator = user
    content {
      name = "cms.users.data.users[${user.key}].username"
      value = user.value.username
    }
  }

  dynamic set_sensitive {
    for_each = var.users
    iterator = user
    content {
      name = "cms.users.data.users[${user.key}].password"
      value = user.value.password
    }
  }

  dynamic set_sensitive {
    for_each = var.users
    iterator = user
    content {
      name = "cms.users.data.users[${user.key}].isAdmin"
      value = user.value.is_admin
    }
  }

  set {
    name = "cms.mongodb.cms.password"
    value = random_password.cms_db_password.result
  }
}
