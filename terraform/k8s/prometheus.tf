# To run if you haven't created a monitoring namespace manually
# resource "kubernetes_namespace" "monitoring" {
#  metadata {
#    name = "monitoring"
#  }
#}

resource "helm_release" "prometheus" {
  name       = "monitoring"
  chart      = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  version    = "25.24.1"
  namespace  = "monitoring"

  set {
    name  = "prometheus.service.type"
    value = "NodePort"
  }
}



