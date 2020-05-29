terraform {
  backend "s3" {}
  required_providers {
    null = "~> 2.1"
  }
}

provider "aws" {
  version = "~> 2.63"
}

module cluster {
  source = "./eks"
}

provider "kubernetes" {
  host                   = module.cluster.host
  cluster_ca_certificate = base64decode(module.cluster.certificate_authority_data)
  config_path            = module.cluster.kubeconfig.filename
  load_config_file       = true
  version                = "~> 1.11"
}

module "kubernetes" {
  source = "../modules/kubernetes"
}

module "storage" {
  source = "./storage"
}

provider "helm" {
  debug = false
  kubernetes {
    host                   = module.cluster.host
    cluster_ca_certificate = base64decode(module.cluster.certificate_authority_data)
    config_path            = module.cluster.kubeconfig_filename
    load_config_file       = true
  }
  version = "~> 1.2"
}

module "store" {
  source = "../modules/store"
  image_pull_secret_names = module.kubernetes.image_pull_secret_names
  ingress_ip_address = module.ingress.public_endpoint
}

module "backend" {
  source = "../modules/backend"
  ingress_ip_address = module.ingress.public_endpoint
  image_pull_secret_names = module.kubernetes.image_pull_secret_names
  pvc_name = module.storage.pvc_name
  timeout = 900
}

module "ingress" {
  source = "./ingress_controller"
}

output "url" {
  value = module.ingress.public_endpoint
}

output "kubeconfig" {
  value = file(module.cluster.kubeconfig.content)
}