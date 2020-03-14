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
      nginx-ingress:
        enabled: true
      keystone-events:
        imagePullSecrets: ${jsonencode(local.image_pull_secrets)}
      keystone-products:
        imagePullSecrets: ${jsonencode(local.image_pull_secrets)}
      keystone-cms:
        imagePullSecrets: ${jsonencode(local.image_pull_secrets)}
        secrets:
          mongodbCms:
            data:
              password: ${random_password.cms_db_password.result}
          users:
            data: ${local.users}
          strings:
            data: ${local.string_values}
        # resources:
        #   main:
        #     requests:
        #       memory: "500Mi"
        #       cpu: "100m"
        #     limits:
        #       memory: "1Gi"
        #       cpu: "500m"
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
        network:
          products: "http://${var.lb_ip_address.address}/products"
          events: "http://${var.lb_ip_address.address}/events"
          resources: "http://${var.lb_ip_address.address}/cms/graphql"
      endpoints-example:
        imagePullSecrets: ${jsonencode(local.image_pull_secrets)}
        endpoints:
          endpoints:
            - name: products
              description: "A standardised interface for products"
              uri: "http://${var.lb_ip_address.address}/products"
            - name: events
              description: "A standardised interface for events"
              uri: "http://${var.lb_ip_address.address}/events"
            - name: cms-graphql
              description: "The graphql endpoint for the cms"
              uri: "http://${var.lb_ip_address.address}/cms/graphql"
            - name: cms-playground
              description: "get to grips with the graphql api provided by the cms with a graphql playground.\\\\nIn order for this to work the cms must be deployed in development mode"
              uri: "http://${var.lb_ip_address.address}/cms/playground"
            - name: cms-admin
              description: "Admins of the cms can view and edit content stored there"
              uri: "http://${var.lb_ip_address.address}/cms"
    EOT
  ]
}
