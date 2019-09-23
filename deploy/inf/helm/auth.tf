resource "helm_release" "auth" {
  depends_on = [ helm_release.istio ]
  
  name       = "auth"
  repository = data.helm_repository.github_master.name
  chart      = "auth"
  version    = "0.0.1"
  namespace  = var.namespaces.main
}