# TODO:
# terraform {
#   backend "gcs" {
#     bucket  = "tf-state-prod"
#     prefix  = "terraform/state"
#   }
# }

provider "google-beta" {
  region = var.google_region
  zone = var.google_region
  project = var.google_project
  # TODO: add another gke key for creds
}

module "cluster" {
  source = "./cluster"
  cluster = var.cluster
  use_istio = var.use_istio
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

  image_pull_secrets = [for s in var.image_pull_secrets : {
    registry = s.registry
    username = s.username
    password = s.password != null ? s.password : file("${path.root}/${s.passwordFile}")
  }] # TODO: transform password file
}

provider "helm" {
  debug = true
  namespace = module.kubernetes.namespaces.helm
  max_history = 10
  home = var.helm_home
  service_account = module.kubernetes.service_account_name

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
  use_istio = var.use_istio
  users = var.users
  lb_ip_address = module.cluster.lb_ip_address
  contact_email = var.contact_email
}
