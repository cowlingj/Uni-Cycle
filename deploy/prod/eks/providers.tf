provider "aws" {
  region                  = "eu-west-2"
  shared_credentials_file = var.aws_credentials_path
  version = "~> 2.63"
}

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

provider local {
  version = "~> 1.4"
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {}

data "aws_eks_cluster_auth" "primary" {
  name = var.cluster_name
}
