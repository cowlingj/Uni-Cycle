
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

data local_file "profile" {
  depends_on = [
    null_resource.minikube_cluster
  ]
  filename = pathexpand("~/.minikube/profiles/${var.profile}/config.json")
}

data null_data_source "lb_ip_address" {

  depends_on = [
    data.local_file.profile
  ]

  count = var.enabled && var.tunnel ? 1 : 0

  inputs = {
    address = jsondecode(data.local_file.profile.content).KubernetesConfig.ServiceCIDR
  }
}
