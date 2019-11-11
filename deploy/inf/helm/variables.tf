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