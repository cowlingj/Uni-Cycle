variable "timeout" {
  type    = number
  default = 900
}

variable "image_pull_secret_names" {
  type    = list(string)
  default = []
}

variable "pvc_name" {
  type = string
}

variable "ingress_ip_address" {
  type = string
}

variable "env" {
  type = string
  default = "production"
}