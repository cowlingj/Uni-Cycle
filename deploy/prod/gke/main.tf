terraform {
  # backend "gcs" {
  #   bucket  = "tf-state-prod"
  #   prefix  = "terraform/state"
  # }
  required_providers {
    google = "~> 3.20.0"
  }
}

provider "google" {
  credentials = "${path.root}/secrets/gke/service-account.json"
  region = "europe-west2"
  zone = "europe-west2-a"
  project = "ecommerce-backend-demo"
}

data "google_client_config" "provider" {}

resource "google_container_cluster" "main" {
  name     = "primary-cluster"
  remove_default_node_pool = true
  initial_node_count = 1

  maintenance_policy {
    daily_maintenance_window {
      start_time = "03:00"
    }
  }

  master_auth {
    username = null
    password = null
    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

resource "google_container_node_pool" "primary_nodes" {
  provider   = google
  name       = "primary-node-pool"
  cluster    = google_container_cluster.main.name
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

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only"
    ]
  }
}

resource "null_resource" "wait" {
  triggers = {
    cluster = google_container_cluster.main.id
    node_pool = google_container_node_pool.primary_nodes.id
  }

  provisioner "local-exec" {
    command = "sleep 120"
  }
}

resource "google_compute_address" "ip_address" {
  region = data.google_client_config.provider.region
  name = "lb-ip-address"
  network_tier = "PREMIUM"
}
