locals {
  cluster = jsondecode(
    file("${path.root}/config/cluster/${var.cluster}/cluster.json")
  )
}

module "google" {
  source = "./google"
  enabled = local.cluster.type == "google"
  use_istio = local.cluster.use_istio
}

module "minikube" {
  source = "./minikube"
  enabled = local.cluster.type == "minikube"
}

resource null_resource "catch_all" {

  triggers = {
    cluster = var.cluster
  }

  provisioner "local-exec" {
    on_failure = fail
    interpreter = [ "bash", "-c" ]
    command = <<-EOF
      case "${var.cluster}" in
        google) ;;
        minikube) ;;
        *)
          echo "there is no module to provision \"${var.cluster}\" cluster"
          exit 1
          ;;
      esac
    EOF
  }
}
