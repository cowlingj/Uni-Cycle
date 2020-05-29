resource "kubernetes_persistent_volume_claim" "pvc" {

  metadata {
    generate_name = "mongodb-pvc-"
    namespace = "default"
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