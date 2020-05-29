provider "kubernetes" {
  host                   = aws_eks_cluster.primary.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.primary.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.primary.token
  load_config_file       = false
  version                = "~> 1.11"
}

provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.primary.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.primary.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.primary.token
    load_config_file       = false
  }
  version = "~> 1.2"
}

terraform {
  required_providers {
    local = "~> 1.4"
    aws   = "~> 2.63"
  }
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {}

data "aws_eks_cluster_auth" "primary" {
  name = var.cluster_name
}
