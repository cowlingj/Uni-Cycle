resource "helm_release" "rancher_local_path" {
  name = "rancher-local-path-provisioner"
  chart = "${path.root}/../charts/local-path-provisioner/"

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