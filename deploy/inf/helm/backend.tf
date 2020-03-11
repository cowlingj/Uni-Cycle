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
  image_pull_secrets = [for secret in var.image_pull_secret_names: {name: secret}]
}

resource "helm_release" "backend" {

  depends_on = [ var._depends_on ]

  timeout = 720

  name       = "ecommerce-backend"
  repository = data.helm_repository.github_master.name
  chart      = "ecommerce-backend"
  version    = "0.0.1"
  namespace  = var.namespaces.main

  values = [
    <<EOT
      tags:
        simple-example: true
        keystone: true
      nginx-ingress:
        enabled: true
        certIssuer: letsencrypt-staging
        domainName: null
        useHttps: false
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
          - path: /events
            service:
              name: keystone-events
              port: 80
          - path: /example
            service:
              name: simple-example
              port: 80
      keystone-events:
        imagePullSecrets: ${jsonencode(local.image_pull_secrets)}
        keystone:
          uri: http://keystone-cms/cms/graphql
        service:
          fullnameOverride: keystone-events
      keystone-products:
        imagePullSecrets: ${jsonencode(local.image_pull_secrets)}
        keystone:
          uri: http://keystone-cms/cms/graphql
        service:
          fullnameOverride: keystone-products
      keystone-cms:
        imagePullSecrets: ${jsonencode(local.image_pull_secrets)}
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
        imagePullSecrets: ${jsonencode(local.image_pull_secrets)}
        rootPassword: ${random_password.root_db_password.result}
      simple-example:
        imagePullSecrets: ${jsonencode(local.image_pull_secrets)}
        service:
          fullnameOverride: simple-example
        basePath: "/example"
        network:
          products: "http://${var.lb_ip_address.address}/products"
          events: "http://${var.lb_ip_address.address}/events"
    EOT
  ]
}
