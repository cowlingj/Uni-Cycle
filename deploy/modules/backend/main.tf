terraform {
  required_providers {
    helm   = "~> 1.2"
    random = "~> 2.2"
  }
}

resource "random_password" "cms_db_password" {
  length  = 32
  special = false
  keepers = {
    storage_id = var.pvc_name
  }
}

resource "random_password" "root_db_password" {
  length  = 32
  special = false
  keepers = {
    storage_id = var.pvc_name
  }
}

locals {
  keystone_cms_config = yamldecode(file("${path.root}/secrets/backend/keystone-cms.yaml"))
}

resource "helm_release" "backend" {

  timeout = var.timeout

  name       = "ecommerce-backend"
  repository = "https://raw.githubusercontent.com/cowlingj/ecommerce-backend/master/helm/repo/"
  chart      = "ecommerce-backend"
  version    = "0.0.1"
  namespace  = "default"

  values = [
    for filename in fileset("${path.module}/values", "**/*.yaml") :
    templatefile("${path.module}/values/${filename}", {
      general = {
        ingress_ip_address = var.ingress_ip_address
        image_pull_secrets = jsonencode([for secret in var.image_pull_secret_names : { name = secret }])
      },
      keystone-cms = {
        cms_db_password = random_password.cms_db_password.result,
        users           = jsonencode(local.keystone_cms_config.users),
        string_values   = jsonencode(local.keystone_cms_config.string_values)
      },
      mongodb = {
        root_db_password = random_password.root_db_password.result,
        pvc_name         = var.pvc_name
      }
    })
  ]
}
