# resource "helm_release" "istio_init" {
#   name       = "istio_init"
#   repository = data.helm_repository.istio.name
#   chart      = "istio-init"
#   namespace  = var.namespaces.istio
# }

resource "helm_release" "istio" {
  # depends_on = [ helm_release.istio_init ]

  name       = "istio"
  repository = data.helm_repository.istio.name
  chart      = "istio"
  namespace  = var.namespaces.istio

  set {
    name = "pilot.resources.requests.cpu"
    value = "100m"
  }

  set {
    name = "pilot.resources.requests.memory"
    value = "256Mi"
  }

    set {
    name = "pilot.resources.limits.cpu"
    value = "100m"
  }

  set {
    name = "pilot.resources.limits.memory"
    value = "256Mi"
  }

  set {
    name = "mixer.telemetry.resources.requests.cpu"
    value = "200m"
  }

  set {
    name = "mixer.telemetry.resources.requests.memory"
    value = "256Mi"
  }

  set {
    name = "mixer.telemetry.resources.limits.cpu"
    value = "200m"
  }

  set {
    name = "mixer.telemetry.resources.limits.memory"
    value = "256Mi"
  }
}