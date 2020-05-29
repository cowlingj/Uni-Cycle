locals {
  endpoint = data.kubernetes_service.ingress_controller.load_balancer_ingress[0]
}

output public_endpoint {
  value = local.endpoint.hostname != "" ? local.endpoint.hostname : local.endpoint.ip
}