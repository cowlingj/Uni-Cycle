resource "helm_release" "store" {

  depends_on = [ var._depends_on ]

  name       = "store"
  chart      = "${path.root}/../../store/charts/store/"
  version    = "0.0.1"
  namespace  = var.namespaces.main

  values = [
    <<EOT
      email: "${jsondecode(file("${path.root}/config/store/contact.json")).contact_email}"
      imagePullSecrets: ${jsonencode(local.image_pull_secrets)}
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
          hostname: keystone-cms
      backend:
        ip: ${var.lb_ip_address.address != null ? var.lb_ip_address.address : ""}
    EOT
  ]
}
