# To run if you haven't created a monitoring namespace manually
# resource "kubernetes_namespace" "monitoring" {
#  metadata {
#    name = "monitoring"
#  }
#}

resource "helm_release" "prometheus_grafana" {
  name       = "monitoring"
  chart      = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  version    = "61.3.2"
  namespace  = "monitoring"

  set {
    name  = "grafana.service.type"
    value = "LoadBalancer"
  }
  set {
    name  = "prometheus.service.type"
    value = "LoadBalancer"
  }
}



