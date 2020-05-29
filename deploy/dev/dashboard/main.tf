# resource "kubernetes_service_account" "dashboard_user" {

#   # depends_on = [
#   #   null_resource.dashboard
#   # ]

#   metadata {
#     generate_name = "dashboard-"
#   }
# }

# resource "kubernetes_cluster_role_binding" "dashboard_user_role_binding" {

#   # depends_on = [
#   #   null_resource.dashboard
#   # ]

#   metadata {
#     name = "dashboard-crb"
#   }

#   role_ref {
#     api_group = "rbac.authorization.k8s.io"
#     kind      = "ClusterRole"
#     name      = "cluster-admin"
#   }

#   subject {
#     kind      = "ServiceAccount"
#     name      = kubernetes_service_account.dashboard_user.metadata[0].name
#   }
# }

# # apiVersion: rbac.authorization.k8s.io/v1
# # kind: ClusterRoleBinding
# # metadata:
# #   name: kubernetes-dashboard
# #   namespace: kubernetes-dashboard
# # roleRef:
# #   apiGroup: rbac.authorization.k8s.io
# #   kind: ClusterRole
# #   name: cluster-admin
# # subjects:
# #   - kind: ServiceAccount
# #     name: kubernetes-dashboard
# #     namespace: kubernetes-dashboard

# # resource "kubernetes_cluster_role_binding" "dashboard_role_binding" {

# #   depends_on = [
# #     null_resource.dashboard
# #   ]

# #   metadata {
# #     name = "dashboard-crb"
# #     # namespace = "kubernetes-dashboard"
# #   }

# #   role_ref {
# #     api_group = "rbac.authorization.k8s.io"
# #     kind      = "ClusterRole"
# #     name      = "cluster-admin"
# #   }

# #   subject {
# #     kind      = "ServiceAccount"
# #     name      = "kubernetes-dashboard"
# #   }
# # }


# resource "null_resource" "dashboard" {

#   triggers = {
#     kubeconfig_location = var.kubeconfig_location
#     dashboard_config_location = var.dashboard_config_location
#   }

#   provisioner local-exec {
#     when = create
#     environment = {
#       KUBECONFIG = self.triggers.kubeconfig_location
#     }
#     command = "kubectl apply -f '${self.triggers.dashboard_config_location}'"
#   }

#   provisioner local-exec {
#     when = destroy
#     environment = {
#       KUBECONFIG = self.triggers.kubeconfig_location
#     }
#     command = "kubectl delete -f '${self.triggers.dashboard_config_location}'"
#   }
# }

# resource "kubernetes_service" "dashboard_service" {
#   depends_on = [
#     null_resource.dashboard
#   ]

#   metadata {
#     generate_name = "dashboard"
#     namespace = "kubernetes-dashboard"
#   }

#   spec {
#     type = "NodePort"
#     port {
#       port = 443
#       target_port = 8443
#       node_port = 30080
#     }
#     selector = {
#       "k8s-app": "kubernetes-dashboard"
#     }
#   }
# }


# apiVersion: v1
# kind: Secret
# metadata:
#   labels:
#     k8s-app: kubernetes-dashboard
#   name: kubernetes-dashboard-csrf
#   namespace: kubernetes-dashboard
# type: Opaque
# data:
#   csrf: ""

resource "kubernetes_secret" "dashboard_csrf" {
  metadata {
    name      = "kubernetes-dashboard-csrf"
    namespace = "kube-system"
  }
  type = "Opaque"
  data = {
    csrf = ""
  }
}

resource "helm_release" "dashboard" {
  name       = "dashboard"
  chart      = "kubernetes-dashboard"
  namespace  = "kube-system"
  repository = "https://kubernetes-charts.storage.googleapis.com"

  set {
    name  = "image.repository"
    value = "kubernetesui/dashboard"
  }

  set {
    name  = "image.tag"
    value = "v2.0.0"
  }

  set {
    name  = "enableInsecureLogin"
    value = true
  }

  set {
    name  = "enableSkipLogin"
    value = true
  }

  set {
    name  = "rbac.clusterAdminRole"
    value = true
  }

  set {
    name  = "fullnameOverride"
    value = "kubernetes-dashboard"
  }
}