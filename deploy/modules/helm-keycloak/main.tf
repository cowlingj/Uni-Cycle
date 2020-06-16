resource "random_password" "admin_password" {
  length = 32
  special = true
}

resource "kubernetes_secret" "keycloak_admin_password" { 
  metadata {
    generate_name = "keycloak-config-admin-"
  }

  data = {
    password = random_password.admin_password.result
  }
}

resource "kubernetes_secret" "keycloak_realms" {
  metadata {
    generate_name = "keycloak-imports-realms-"
  }

  data = merge([
    for filename in  fileset("${path.root}/secrets/backend/keycloak/imports/realms/", "**/*.json"):
{
      "${filename}": templatefile(
        "${path.root}/secrets/backend/keycloak/imports/realms/${filename}", {
          for key, value in jsondecode(file("${path.root}/secrets/backend/keycloak/passwords.json")):
          key => {
            secret_data = replace(
              jsonencode({
                value = value.password
                salt = value.salt
              }),
              "/([\\\"])/",
              "\\$1"
            )
            credential_data = replace(
                jsonencode({
                  hashIterations = value.hash_info.hashIterations
                  algorithm = value.hash_info.algorithm
                }),
                "/([\\\"])/",
                "\\$1"
            )
          }
        })
    }
  ]...)
}

resource "helm_release" "keycloak" {
  name       = "keycloak"
  repository = "https://codecentric.github.io/helm-charts/"
  chart      = "keycloak"
  version    = "8.2.2"
  namespace  = "default"

  values = [
    templatefile("${path.module}/values.yaml", {
      keycloak = {
        extra_args = join(" ",
          [
            "-Dkeycloak.import=${join(",", [
              for filename in  fileset("${path.root}/secrets/backend/keycloak/imports/realms", "**/*.json"):
              "/etc/keycloak/realms/${filename}"
            ])}"
          ]
        )
        volume_mounts = indent(4, "    ${yamlencode([
          {
            name = "import-realms"
            mountPath = "/etc/keycloak/realms/"
            readOnly = true
          }
        ])}")
        volumes = indent(4, "    ${yamlencode([
          {
            name = "import-realms"
            secret = {
              secretName = kubernetes_secret.keycloak_realms.metadata.0.name
            }
          }
        ])}")
        admin_secret_name = kubernetes_secret.keycloak_admin_password.metadata.0.name
      }
    })
  ]
}
