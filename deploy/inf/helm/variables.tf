variable "namespaces" {
  type = object({
    main = string
    istio = string
  })
}

variable "_depends_on" {
  type = "list"
  default = []
}

variable "image_pull_secret_names" {
  type = list(string)
  default = []
}

variable "pvc_name" {
  type = string
}

variable "cluster" {
  type = string
  default = "minikube"
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

variable lb_ip_address {
  type = object({ name = string, address = string})
}
