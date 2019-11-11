resource "kubernetes_persistent_volume_claim" "pvc" {

  metadata {
    generate_name = "mongodb-pvc-"
    namespace = kubernetes_namespace.main.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "128Mi"
      }
    }
  }
}