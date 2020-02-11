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

variable use_istio {
  type = bool
  default = true
}

variable "users" {
  type = list(object({
    username = string
    password = string
    is_admin = bool
  }))
  default = []
}

variable "contact_email" {
  type = string
}
