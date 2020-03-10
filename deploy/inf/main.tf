terraform {
  # backend "gcs" {
  #   bucket  = "tf-state-prod"
  #   prefix  = "terraform/state"
  # }
  required_providers {
    google-beta = "~> 3.11.0"
    helm = "~> 1.0.0"
    kubernetes = "~> 1.11.1"
    local = "~> 1.4.0"
    null = "~> 2.1.2"
    random = "~> 2.2.1"
  }
}

provider "google-beta" {
  region = var.google_region
  zone = var.google_region
  project = var.google_project
  # TODO: add another gke key for creds
}

module "cluster" {
  source = "./cluster"
  cluster = var.cluster
}

provider "kubernetes" {
    load_config_file = module.cluster.kubernetes_config.load_config_file
    config_context = module.cluster.kubernetes_config.config_context
    host = module.cluster.kubernetes_config.host
    client_certificate = module.cluster.kubernetes_config.client_certificate
    cluster_ca_certificate = module.cluster.kubernetes_config.cluster_ca_certificate
    client_key = module.cluster.kubernetes_config.client_key
    username = module.cluster.kubernetes_config.username
    password = module.cluster.kubernetes_config.password
    insecure = module.cluster.kubernetes_config.insecure
  }

module "kubernetes" {
  source = "./kubernetes"
  cluster = var.cluster
}

provider "helm" {
  debug = true
  kubernetes {
    load_config_file = module.cluster.kubernetes_config.load_config_file
    config_context = module.cluster.kubernetes_config.config_context
    host = module.cluster.kubernetes_config.host
    client_certificate = module.cluster.kubernetes_config.client_certificate
    cluster_ca_certificate = module.cluster.kubernetes_config.cluster_ca_certificate
    client_key = module.cluster.kubernetes_config.client_key
    username = module.cluster.kubernetes_config.username
    password = module.cluster.kubernetes_config.password
    insecure = module.cluster.kubernetes_config.insecure
  }
}

module "helm" {
  source = "./helm"
  namespaces = module.kubernetes.namespaces
  image_pull_secret_names = module.kubernetes.image_pull_secret_names
  pvc_name = module.kubernetes.pvc_name
  cluster = var.cluster
  lb_ip_address = module.cluster.lb_ip_address
}
