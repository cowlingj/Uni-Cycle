# terraform {
#   backend "gcs" {
#     bucket  = "tf-state-prod"
#     prefix  = "terraform/state"
#   }
# }

provider "google-beta" {
  region = var.google_region
  project = var.google_project
}

provider "helm" {
  debug = true
  namespace = module.kubernetes.namespaces.helm
  max_history = 10
  home = var.helm_home
  service_account = module.kubernetes.service_account_name
  kubernetes { 
    config_context = "gke_${var.google_project}_${var.google_region}_main"
  }
}

provider "kubernetes" {
  config_context = "gke_${var.google_project}_${var.google_region}_main"
}

module "helm" {
  source = "./helm"
  namespaces = module.kubernetes.namespaces
}

module "kubernetes" {
  source = "./kubernetes"
}
