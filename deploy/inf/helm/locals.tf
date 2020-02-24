locals {
  use_istio = jsondecode(file("${path.root}/config/cluster/${var.cluster}.json")).use_istio
}
