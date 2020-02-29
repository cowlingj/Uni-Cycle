locals {
  use_istio = jsondecode(file("${path.root}/config/cluster/${var.cluster}/cluster.json")).use_istio
}
