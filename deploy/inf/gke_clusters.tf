# resource "google_container_cluster" "main" {
#   provider = "google-beta"
#   name     = "tf-gke-cluster"
#   location = "europe-west1-b"

#   remove_default_node_pool = true
#   initial_node_count = 1

#   addons_config {
#     istio_config {
#       disabled = true
#     }
#   }

#   maintenance_policy {
#     daily_maintenance_window {
#       start_time = "03:00"
#     }
#   }

#   master_auth {
#     username = ""
#     password = ""

#     client_certificate_config {
#       issue_client_certificate = false
#     }
#   }
# }

# resource "google_container_node_pool" "primary_preemptible_nodes" {
#   provider   = "google-beta"
#   name       = "my-node-pool"
#   location   = "europe-west1-b"
#   cluster    = "${google_container_cluster.main.name}"
#   node_count = 1

#   node_config {
#     preemptible  = false
#     machine_type = "g1-small"

#     metadata = {
#       disable-legacy-endpoints = "true"
#     }

#     oauth_scopes = [
#       "https://www.googleapis.com/auth/logging.write",
#       "https://www.googleapis.com/auth/monitoring",
#     ]
#   }
# }