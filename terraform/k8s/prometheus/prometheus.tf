# Versions and necessary releases found with helm search repo prometheus-community

resource "helm_release" "prometheus" {
  # Installs node-exporter (node monitoring), kube-state-metrics (kubernetes components monitoring), prometheus-operator (auto-discovery)
  name       = "monitoring"
  chart      = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  version    = "61.3.2"
  namespace  = "monitoring"

  set {
    name  = "alertmanager.enabled"
    value = "false"
  }
  set {
    name  = "grafana.enabled"
    value = "false"
  }
  set {
    name  = "prometheus.enabled"
    value = "false"
  }
  set {
    name  = "prometheus-node-exporter.service.type"
    value = "NodePort"
  }
  set {
    name  = "kube-state-metrics.service.type"
    value = "NodePort"
  }
  set {
    name  = "prometheusOperator.service.type"
    value = "NodePort"
  }
}


resource "helm_release" "mongodb" {
  # exporter is exposed on port 9216, unless you change it
    name       = "mongodb-monitoring"
  chart      = "prometheus-mongodb-exporter"
  repository = "https://prometheus-community.github.io/helm-charts"
  
  version    = "3.5.0"
  namespace  = "monitoring"
  set {
    # Mongodb-uri
    name  = "existingSecret.name"
    value = "backend-secrets"
  }
  set {
    name  = "service.type"
    value = "NodePort"
  }
  

}

resource "helm_release" "redis" {
  # redis exporter is on port 9121
    name       = "redis-monitoring"
  chart      = "prometheus-redis-exporter"
  repository = "https://prometheus-community.github.io/helm-charts"
  version    = "6.3.0"
  namespace  = "monitoring"
  set {
    name  = "service.type"
    value = "NodePort"
  }
  set {
    name  = "redisAddress"
    value = "redis://redis:6379"
  }

  set {
    name  = "auth.enabled"
    value = "true"
  }
  set {
    name  = "auth.secret.name"
    value = "backend-secrets"
  }
  set {
    name  = "auth.secret.key"
    value = "redis-service-password"
  }

}






