resource "helm_release" "rancher_local_path" {
  name = "rancher-local-path-provisioner"
  # chart = "local-path-provisioner"
  chart = "${path.root}/../charts/local-path-provisioner/"
  # chart = "https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/chart/Chart.yaml"

  # set {
  #   name = "storageclass.default"
  # }

  set {
    name  = "storageClass.provisionerName"
    value = "rancher-local-path"
  }
}

output "storageclassname" {
  value = helm_release.rancher_local_path.values
}

resource "kubernetes_persistent_volume_claim" "pvc" {

  depends_on = [
    helm_release.rancher_local_path
  ]

  metadata {
    generate_name = "mongodb-pvc-"
    namespace     = "default"
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    # storage_class_name = "${yamldecode(helm_release.rancher-local-path.values).storageClass.name}"
    # storage_class_name = "rancher-local-path"
    resources {
      requests = {
        storage = "128Mi"
      }
    }
  }

  wait_until_bound = false
}

output "pvc_name" {
  value = kubernetes_persistent_volume_claim.pvc.metadata[0].name
}