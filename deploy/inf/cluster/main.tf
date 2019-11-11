module "google" {
  source = "./google"
  enabled = var.cluster == "google"
}

module "minikube" {
  source = "./minikube"
  enabled = var.cluster == "minikube"
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