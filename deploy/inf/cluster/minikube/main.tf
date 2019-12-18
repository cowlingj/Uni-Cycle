
resource null_resource "minikube_cluster" {

  triggers = {
    profile = var.profile
  }

  count = var.enabled ? 1 : 0

  provisioner "local-exec" {
    when = "create"
    command = "minikube start --kubernetes-version=1.14.8 --profile=${var.profile}"
    interpreter = [ "bash", "-c" ]
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "minikube delete --profile=${var.profile}"
    interpreter = [ "bash", "-c" ]
  }
}
