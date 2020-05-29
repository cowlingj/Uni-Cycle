# replace the default kube-system/configmap/aws-auth for granting nodes, iam users, and roles access to the cluster

resource "kubernetes_config_map" "aws_auth" {
  depends_on = [
    null_resource.delete_old_aws_auth
    # null_resource.wait_for_cluster
  ]

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode(distinct(concat(local.mapNodeRoles)))
    # mapUsers = yamlencode(distinct(concat(local.mapCallerUser)))
    # mapAccounts = yamlencode(var.map_accounts)
  }
}

resource null_resource "delete_old_aws_auth" {

  depends_on = [
    null_resource.wait_for_cluster
  ]

  triggers = {
    kubeconfig = local_file.kubeconfig.filename
    region     = data.aws_region.current.name
  }

  provisioner local-exec {
    command = "kubectl delete configmap aws-auth -n kube-system"
    environment = {
      KUBECONFIG = self.triggers.kubeconfig
    }
  }
}