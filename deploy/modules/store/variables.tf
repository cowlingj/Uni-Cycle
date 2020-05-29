variable "image_pull_secret_names" {
  type    = list(string)
  default = []
}

variable "ingress_ip_address" {
  type    = string
  default = "127.0.0.1"
}