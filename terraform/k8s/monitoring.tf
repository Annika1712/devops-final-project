resource "helm_release" "prometheus_grafana" {
  depends_on = [kubernetes_namespace_v1.this]
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