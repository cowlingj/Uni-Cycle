variable "cluster_name" {
  default = "terraform-eks-demo"
  type    = string
}

variable kubernetes_version_major {
  type    = number
  default = 1
}

variable kubernetes_version_minor {
  type    = number
  default = 16
}

variable kubernetes_version_patch {
  type    = number
  default = 3
}