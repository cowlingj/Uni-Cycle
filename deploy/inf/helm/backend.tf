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
  users = file("${path.root}/.secrets/cms/default-users.json")
  string_values = file("${path.root}/.secrets/cms/default-strings.json")
}

resource "helm_release" "backend" {

  depends_on = [ var._depends_on ]

  timeout = 720

  name       = "ecommerce-backend"
  repository = data.helm_repository.github_master.name
  chart      = "ecommerce-backend"
  version    = "0.0.1"
  namespace  = var.namespaces.main

  # dynamic set {
  #   for_each = var.image_pull_secret_names
  #   iterator = each
  #   content {
  #     name = "keystone-cms.imagePullSecrets[${each.key}].name"
  #     value = each.value
  #   }
  # }

  # dynamic set {
  #   for_each = var.image_pull_secret_names
  #   iterator = each
  #   content {
  #     name = "keystone-events.imagePullSecrets[${each.key}].name"
  #     value = each.value
  #   }
  # }

  # dynamic set {
  #   for_each = var.image_pull_secret_names
  #   iterator = each
  #   content {
  #     name = "keystone-products.imagePullSecrets[${each.key}].name"
  #     value = each.value
  #   }
  # }

  # dynamic set {
  #   for_each = var.image_pull_secret_names
  #   iterator = each
  #   content {
  #     name = "simple-example.imagePullSecrets[${each.key}].name"
  #     value = each.value
  #   }
  # }

  values = [
    <<EOT
      tags:
        simple-example: true
        nginx-ingress: true
        keystone: true
      nginx-ingress:
        paths:
          - path: /cms
            service:
              name: keystone-cms
              port: 80
          - path: /products
            service:
              name: keystone-products
              port: 80
          - path: /store
            service:
              name: store
              port: 80
          - path: /example
            service:
              name: simple-example
              port: 80
          - path: /events
            service:
              name: keystone-events
              port: 80
      keystone-events:
        imagePullSecrets: ${jsonencode(var.image_pull_secret_names)}
        keystone:
          uri: http://keystone-cms/cms/graphql
        service:
          fullnameOverride: keystone-events
      keystone-products:
        imagePullSecrets: ${jsonencode(var.image_pull_secret_names)}
        keystone:
          uri: http://keystone-cms/cms/graphql
        service:
          fullnameOverride: keystone-products
      keystone-cms:
        imagePullSecrets: ${jsonencode(var.image_pull_secret_names)}
        basePath: "/cms"
        service:
          fullnameOverride: keystone-cms
        secrets:
          mongodbCms:
            data:
              password: ${random_password.cms_db_password.result}
          mongodbAdmin:
            fullnameOverride: mongodb-config
          users:
            data: ${local.users}
          strings:
            data: ${local.string_values}
        resources:
          main:
            requests:
              memory: "500Mi"
              cpu: "100m"
            limits:
              memory: "1Gi"
              cpu: "500m"
      mongodb:
        persistence:
          existingClaim: ${var.pvc_name}
        volumePermissions:
          enabled: true
      mongodb-config:
        imagePullSecrets: ${jsonencode(var.image_pull_secret_names)}
        rootPassword: ${random_password.root_db_password.result}
      simple-example:
        imagePullSecrets: ${jsonencode(var.image_pull_secret_names)}
        service:
          fullnameOverride: simple-example
        basePath: "/example"
        network:
          products: "http://${var.lb_ip_address.address}/products"
          events: "http://${var.lb_ip_address.address}/events"
      nginx-ingress:
        enabled: true
        certIssuer: letsencrypt-staging
        domainName: null
        useHttps: false
    EOT
  ]

  # TODO: check things still work without this
  # set {
  #   name = "mongodb.volumePermissions.enabled"
  #   value = var.cluster == "google"
  # }

  # dynamic set_string {
  #   for_each = local.string_values
  #   iterator = string_value
  #   content {
  #     name = "cms.strings.data.strings[${string_value.key}].value"
  #     value = replace(replace(string_value.value.value, "/\n/", "\n"), ",", "\\,")
  #   }
  # }
}
