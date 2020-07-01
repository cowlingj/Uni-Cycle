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

resource "random_password" "keycloak_admin_password" {
  length = 32
  special = true
}

resource "kubernetes_secret" "keycloak_admin_password" { 
  metadata {
    generate_name = "keycloak-config-admin-"
  }

  data = {
    password = random_password.keycloak_admin_password.result
  }
}

locals {
  keycloak_passwords = jsondecode(
    file("${path.root}/secrets/backend/keycloak/passwords.json")
  )
  keycloak_client_secrets = jsondecode(
    file("${path.root}/secrets/backend/keycloak/client-secrets.json")
  )
}

resource "kubernetes_secret" "keystone_cms_keycloak" {
  
  for_each = local.keycloak_client_secrets

  metadata {
    generate_name = "keystone-cms-keycloak-"
  }

  data = {
    client_secret = each.value.secret
  }
}

data "external" "keycloak_passwords" {

  count = length(local.keycloak_passwords)

  program = ["python", "${path.module}/keycloak-passwords.py"]

  query = {
    password = local.keycloak_passwords[count.index].password
  }
}

resource "kubernetes_secret" "keycloak_realms" {
  metadata {
    generate_name = "keycloak-imports-realms-"
  }

  data = {
      "realms.json": templatefile(
        "${path.root}/secrets/backend/keycloak/imports/realms.json",
        merge(
          {
            for key, client_secret in local.keycloak_client_secrets:
            key => {
              client = client_secret
            }
          },
          {
            for index in range(length(local.keycloak_passwords)):
            local.keycloak_passwords[index].key => {
              secretData = trim(jsonencode(data.external.keycloak_passwords[index].result["secretData"]), "\"")
              credentialData = trim(jsonencode(data.external.keycloak_passwords[index].result["credentialData"]), "\"")
            }
          }
        )
      )
    }
}

resource "helm_release" "backend" {

  timeout = var.timeout

  name       = "ecommerce-backend"
  repository =  "https://raw.githubusercontent.com/cowlingj/ecommerce-backend/master/helm/repo/"
  chart      = "ecommerce-backend"
  version    = "0.0.4"
  namespace  = "default"

  values = [
    for filename in fileset("${path.module}/values", "**/*.yaml") :
    templatefile("${path.module}/values/${filename}", {
      general = {
        env = var.env
        endpoint = var.ingress_ip_address
        image_pull_secrets = jsonencode([for secret in var.image_pull_secret_names : { name = secret }])
      },
      keystone-cms = {
        cms_db_password = random_password.cms_db_password.result,
        users           = jsonencode(local.keystone_cms_config.users),
        string_values   = jsonencode(local.keystone_cms_config.string_values)
        admin_secret    = kubernetes_secret.keystone_cms_keycloak["keystone_cms"].metadata.0.name
        api_secret      = kubernetes_secret.keystone_cms_keycloak["keystone_cms"].metadata.0.name
      },
      mongodb = {
        root_db_password = random_password.root_db_password.result,
        pvc_name         = var.pvc_name
      },
      keycloak = {
        extra_args = join(" ",
          [
            "-Dkeycloak.migration.strategy=OVERWRITE_EXISTING",
            "-Dkeycloak.migration.action=import",
            "-Dkeycloak.migration.provider=singleFile",
            "-Dkeycloak.migration.file=/etc/keycloak/import/realms.json"
          ]
        )
        import_realms_secret_name = kubernetes_secret.keycloak_realms.metadata.0.name
        admin_secret_name = kubernetes_secret.keycloak_admin_password.metadata.0.name
      }
    })
  ]
}
