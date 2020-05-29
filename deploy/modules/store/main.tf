resource "helm_release" "store" {
  name      = "store"
  chart     = "${path.root}/../../store/charts/store/"
  version   = "0.0.1"
  namespace = "default"

  values = [
    <<EOT
      email: "hello@uni-cycle.org.uk"
      imagePullSecrets: ${jsonencode([for secret in var.image_pull_secret_names : { name = secret }])}
      events:
        internal:
          hostname: events
      products:
        internal:
          hostname: products
      resources:
        external:
          path: /cms/graphql
        internal:
          path: /cms/graphql
          hostname: cms
      backend:
        ip: ${var.ingress_ip_address}
    EOT
  ]
}