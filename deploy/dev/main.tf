
terraform {
  required_providers {
    null       = "~> 2.1"
    kubernetes = "~> 1.11.2"
    local      = "~> 1.4.0"
  }
}

module cluster {
  source = "./kind"
}

provider "kubernetes" {
  config_path = module.cluster.kubeconfig_location
}

module "storage" {
  source = "./storage/"
}

module "dashboard" {
  source = "./dashboard"
}

module "kubernetes" {
  source = "../modules/kubernetes"
}

provider "helm" {
  debug = true
  kubernetes {
    config_path = module.cluster.kubeconfig_location
  }
}

module "store" {
  source                  = "../modules/store"
  image_pull_secret_names = module.kubernetes.image_pull_secret_names
  ingress_ip_address      = "localhost:9080"
}

module "backend" {
  source                  = "../modules/backend"
  ingress_ip_address      = "localhost:9080"
  image_pull_secret_names = module.kubernetes.image_pull_secret_names
  pvc_name                = module.storage.pvc_name
}

module "ingress" {
  source = "./ingress"
}