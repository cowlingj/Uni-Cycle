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
  prismic = jsondecode(file("${path.root}/.secrets/credentials/prismic.json"))
  izettle = jsondecode(file("${path.root}/.secrets/credentials/izettle.demo.json"))
}

resource "helm_release" "backend" {

  depends_on = [ var._depends_on ]

  timeout = 1200

  name       = "ecommerce-backend"
  repository = data.helm_repository.github_master.name
  chart      = "ecommerce-backend"
  version    = "0.0.1"
  namespace  = var.namespaces.main

  values = [
    # Demo 1: the example services
    <<EOT
      tags:
        simple-example: true
        endpoints-example: true
        nginx-ingress: true
        keystone: false
        keystone-events: false
        keystone-products: true
        keystone-cms: true
        prismic-events: true

      prismic-events:
        env: development
        service:
          fullnameOverride: prismic-events
        imagePullSecrets: ${jsonencode(local.image_pull_secrets)}
        prismic:
          accessToken: "${local.prismic.auth_token}"
          uri:
            refs: "https://${local.prismic.repo}.prismic.io/api/v2"
            graphql: "https://${local.prismic.repo}.prismic.io/graphql"
      keystone-products:
        env: development
        imagePullSecrets: ${jsonencode(local.image_pull_secrets)}
      keystone-cms:
        features:
          events: ""
        imagePullSecrets: ${jsonencode(local.image_pull_secrets)}
        secrets:
          mongodbCms:
            data:
              password: ${random_password.cms_db_password.result}
          users:
            data: ${local.users}
          strings:
            data: ${local.string_values}

      simple-example:
        basePath: /example
        service:
          fullnameOverride: simple
        imagePullSecrets: ${jsonencode(local.image_pull_secrets)}
        network:
          products: "http://${var.lb_ip_address.address}/products"
          events: "http://${var.lb_ip_address.address}/events"
          resources: "http://${var.lb_ip_address.address}/cms/graphql"
      endpoints-example:
        basePath: /
        service:
          fullnameOverride: endpoints
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
            - name: cms-admin
              description: "Admins of the cms can view and edit content stored there"
              uri: "http://${var.lb_ip_address.address}/cms"
            - name: example-frontend
              description: "A simple html frontend that uses the api"
              uri: "http://${var.lb_ip_address.address}/example"
            - name: prismic-repo
              description: "The admin interface for data stored in prismic.io"
              uri: "https://${local.prismic.repo}.prismic.io/"
      mongodb:
        persistence:
          existingClaim: ${var.pvc_name}
      mongodb-config:
        imagePullSecrets: ${jsonencode(local.image_pull_secrets)}
        rootPassword: ${random_password.root_db_password.result}
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
          - path: /events
            service:
              name: prismic-events
              port: 80
          - path: /example
            service:
              name: simple
              port: 80
          - path: /
            service:
              name: endpoints
              port: 80
    EOT

    # Demo 2: external services
    # <<EOT
    #   tags:
    #     nginx-ingress: true
    #     keystone: false
    #     keystone-cms: true
    #     keystone-products: false
    #     keystone-events: true
    #     izettle-products: true
    #     prismic-events: false

    #   keystone-events:
    #     imagePullSecrets: ${jsonencode(local.image_pull_secrets)}
    #     keystone:
    #       uri: http://cms:80/cms/graphql
    #     service:
    #       fullnameOverride: events

    #   izettle-products:
    #     imagePullSecrets: ${jsonencode(local.image_pull_secrets)}
    #     service:
    #       fullnameOverride: products
    #     secrets:
    #       credentials:
    #         nameOverride: null
    #         exists: false
    #         data:
    #           credentials:
    #             username: ${local.izettle.username}
    #             password: ${local.izettle.password}
    #             client_id: ${local.izettle.client_id}
    #             client_secret: ${local.izettle.client_secret}

    #   keystone-cms:
    #     service:
    #       fullnameOverride: cms
    #     features:
    #       products: ""
    #     imagePullSecrets: ${jsonencode(local.image_pull_secrets)}
    #     secrets:
    #       mongodbCms:
    #         data:
    #           password: ${random_password.cms_db_password.result}
    #       users:
    #         data: ${local.users}
    #       strings:
    #         data: ${local.string_values}
    #   mongodb:
    #     persistence:
    #       existingClaim: ${var.pvc_name}
    #   mongodb-config:
    #     imagePullSecrets: ${jsonencode(local.image_pull_secrets)}
    #     rootPassword: ${random_password.root_db_password.result}
    #   nginx-ingress:    
    #     paths:
    #       - path: /store
    #         service:
    #           name: store
    #           port: 80
    #       - path: /cms
    #         service:
    #           name: cms
    #           port: 80
    #       - path: /products
    #         service:
    #           name: products
    #           port: 80
    #       - path: /events
    #         service:
    #           name: events
    #           port: 80
    # EOT
  ]
}
