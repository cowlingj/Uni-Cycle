resource "helm_release" "store" {
  name      = "store"
  chart     = "${path.root}/../../store/charts/store/"
  version   = "0.0.1"
  namespace = "default"

  # ingress_ip_address (incorrectly) includes port
  # so we can set the external ports to an empty string to
  # just use the ingress_ip_address on its own
  values = [
    <<EOT
      email: "hello@uni-cycle.org.uk"
      imagePullSecrets: ${jsonencode([for secret in var.image_pull_secret_names : { name = secret }])}
      events:
        internal:
          hostname: events
        external:
          port: ""
      products:
        internal:
          hostname: products
        external:
          port: ""
      resources:
        external:
          path: /cms/graphql
          port: ""
        internal:
          path: /cms/graphql
          hostname: cms
      backend:
        hostname: ${var.ingress_ip_address}
    EOT
  ]
}