# resource kubernetes_storage_class "storage" {
#   metadata {
#     generate_name = "storageclass-"
#   }
#   storage_provisioner = "kubernetes.io/gce-pd"
#   reclaim_policy      = "Retain"
#   parameters = {
#     type = "pd-standard"
#   }
# }