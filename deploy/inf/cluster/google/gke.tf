resource "google_container_cluster" "main" {
  count = var.enabled ? 1: 0
  provider = "google-beta"
  name     = "tf-gke-cluster"

  remove_default_node_pool = true
  initial_node_count = 1

  addons_config {
    istio_config {
      # disabled = true
    }
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = "03:00"
    }
  }

  master_auth {
    username = "testtesttesttest"
    password = "testtesttesttest"
  }
}

resource "google_container_node_pool" "primary_nodes" {
  count = var.enabled ? 1: 0
  provider   = "google-beta"
  name       = "my-node-pool"
  cluster    = google_container_cluster.main[count.index].name
  # node_count = 1
  initial_node_count = 1

  autoscaling {
    min_node_count = 0
    max_node_count = 5
  }

  management {
    auto_repair = true
    auto_upgrade = true
  }

  node_config {
    preemptible  = false
    machine_type = "g1-small"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only"
    ]
  }
}

resource "null_resource" "wait" {
  count = var.enabled ? 1: 0
  
  triggers = {
    cluster = google_container_cluster.main[count.index].id
    node_pool = google_container_node_pool.primary_nodes[count.index].id
  }

  provisioner "local-exec" {
    command = "sleep 300"
  }
}

# resource "google_compute_disk" "default" {
#   count = var.enabled ? 1: 0
#   project = var.google_project
#   name  = "mongodb-disk"
#   type  = "pd-ssd"
#   zone  = "europe-west2-a"
#   # image = "debian-8-jessie-v20170523"
#   # labels = {
#   #   environment = "dev"
#   # }
#   # physical_block_size_bytes = 4096
# }