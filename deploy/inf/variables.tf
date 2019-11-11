variable "google_region" {
  type = string
}

variable "google_project" {
  type = string
}

variable "helm_home" {
  type = string
}

variable "cluster" {
  type = string
}

variable image_pull_secrets {
  type = list(object({
      registry = string
      username = string
      password = string
      passwordFile = string
    }))
  default = []
}