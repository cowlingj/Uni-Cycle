variable "_depends_on" {
  type = "list"
  default = []
}

variable image_pull_secrets {
  type = list(object({
    registry = string
    username = string
    password = string
  }))
}
