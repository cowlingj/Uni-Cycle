variable "timeout" {
  type = number
  default = 300
}

variable "image_pull_secret_names" {
  type = list(string)
  default = []
}

variable "pvc_name" {
  type = string
}

variable "ingress_ip_address" {
  type = string
}