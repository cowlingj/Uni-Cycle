resource "helm_release" "istio_init" {

  count = local.use_istio ? 1 : 0

  name       = "istio_init"
  chart      = "istio-init"
  namespace  = var.namespaces.istio
  repository = data.helm_repository.istio.name

  timeout = 600
}

resource "null_resource" "wait_for_crds" {

  count = local.use_istio ? 1 : 0

  triggers = {
    init = helm_release.istio_init[0].id
  }

  provisioner "local-exec" {
    command = "kubectl -n '${var.namespaces.istio}' wait --for=condition=complete job --all --timeout 10m"
  }
}


resource "helm_release" "istio" {

  depends_on = [ helm_release.istio_init, null_resource.wait_for_crds ]

  count = local.use_istio ? 1 : 0

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
