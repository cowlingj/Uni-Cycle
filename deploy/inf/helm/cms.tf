resource "helm_release" "cms" {
  depends_on = [ helm_release.istio ]

  name       = "cms"
  repository = data.helm_repository.github_master.name
  chart      = "cms"
  version    = "0.0.1"
  namespace  = var.namespaces.main
}