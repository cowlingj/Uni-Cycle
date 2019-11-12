resource "random_string" "cms_db_password" {
  length = 32
  special = false
}

resource "random_string" "root_db_password" {
  length = 32
  special = false
}

output "rootPw" {
  value = random_string.root_db_password.result
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

  timeout = 600
  
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

  set_sensitive {
    name = "mongodb-config.rootPassword"
    value = random_string.root_db_password.result
  }

  set {
    name = "mongodb.image.registry"
    value = "gcr.io"
  }

  set {
    name = "mongodb.image.repository"
    value = "gke-test-253221/mongodb.data"
  }

  set {
    name = "mongodb.image.tag"
    value = "0.0.1"
  }

  set_sensitive { # TODO: integrate into backend (use an override host flag)
    name = "cms.mongodbHost"
    value = "mongodb.${var.namespaces.main}.svc.cluster.local:8080"
  }

  set { # TODO: make variable
    name = "cms.users.list[0].email"
    value = "admin@test.com"
  }

  set {
    name = "cms.users.list[0].password"
    value = "admin1"
  }
}
