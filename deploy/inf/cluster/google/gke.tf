resource "random_password" "username" {
  length = 32
  special = false
}

resource "random_password" "password" {
  length = 32
  special = false
}

resource "google_container_cluster" "main" {
  count = var.enabled ? 1: 0
  provider = google-beta
  name     = "tf-gke-cluster"

  remove_default_node_pool = true
  initial_node_count = 1

  addons_config {
    istio_config {
      disabled = !var.use_istio
    }
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = "03:00"
    }
  }

  min_master_version = "1.15.8-gke.3" #"1.14.8-gke.33"

  master_auth {
    username = random_password.username.result
    password = random_password.password.result
  }
}

resource "google_container_node_pool" "primary_nodes" {
  count = var.enabled ? 1: 0
  provider   = google-beta
  name       = "my-node-pool"
  cluster    = google_container_cluster.main[count.index].name
  initial_node_count = 3

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
    command = "sleep 120"
  }
}

resource "google_compute_address" "ip_address" {
  provider = google-beta

  region = "europe-west1"
  count = var.enabled ? 1: 0
  name = "lb-ip-address"
  network_tier = "PREMIUM"
}

