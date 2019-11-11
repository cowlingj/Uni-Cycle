data "helm_repository" "github_master" {
    name = "master"
    url  = "https://raw.githubusercontent.com/cowlingj/ecommerce-backend/master/helm/repo/"
}

data "helm_repository" "istio" {
    name = "istio"
    url = "https://storage.googleapis.com/istio-release/releases/1.1.7/charts/"
}

data "helm_repository" "stable" {
    name = "stable"
    url = "https://kubernetes-charts.storage.googleapis.com"
}