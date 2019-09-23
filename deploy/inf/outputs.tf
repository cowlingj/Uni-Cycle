output "service_account_name" {
  value = module.kubernetes.service_account_name
}

output "helm_namespace" {
  value = module.kubernetes.namespaces.helm
}