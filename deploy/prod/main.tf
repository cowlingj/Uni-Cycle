terraform {
  backend "s3" {
    bucket = var.aws_s3_bucket_name
    key    = var.aws_s3_bucket_object_key
    region = data.aws_region.current.name
  }
  required_providers {
    null = "~> 2.1"
  }
}

provider "aws" {
  region                  = "eu-west-2"
  shared_credentials_file = var.aws_shared_credentials_file
  version = "~> 2.63"
}

data "aws_region" "current" {}

module cluster {
  source = "./eks"
  aws_credentials_path = var.aws_shared_credentials_file
}

provider "kubernetes" {
  host                   = module.cluster.host
  cluster_ca_certificate = base64decode(module.cluster.certificate_authority_data)
  config_path            = module.cluster.kubeconfig_filename
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