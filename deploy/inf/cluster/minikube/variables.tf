variable "enabled" {
  type = bool
  default = false
}

# NOTE: this must be set to a kubernetes context that already exists?
# or kubernetes  provider won't work
# issue: https://github.com/hashicorp/terraform/issues/4149
# TODO: try alternative using local exec to print out variable (tf won't know their identical)
# The data.external provider might be what I need
variable "profile" {
  type = string
  default = "minikube"
}

variable "tunnel" {
  type = bool
  default = false
}
