resource "kubernetes_manifest" "mongodb" {
  manifest = {
    "apiVersion" = "monitoring.coreos.com/v1"
    "kind"       = "ServiceMonitor"
    "metadata" = {
      "name"      = "prometheus-mongodb-exporter"
      "labels" = {
        "app.kubernetes.io/component" = "metrics"
        "app.kubernetes.io/instance" = "monitoring"
        "app.kubernetes.io/name" = "prometheus-mongodb-exporter"
        "app.kubernetes.io/part-of" = "prometheus-mongodb-exporter"
      }
      "namespace" = "monitoring"
    }
    "spec" = {
        "endpoints" = [{
            "port" = "metrics"
            "interval" = "30s"
            "scrapeTimeout" = "10s"
        }]
        "namespaceSelector" = {
            "matchNames" = ["*"]
        }
        "selector" = {
            "matchLabels" = {
                "app.kubernetes.io/instance" = "monitoring"
                "app.kubernetes.io/name" = "prometheus-mongodb-exporter"
                }
        }
    }
  }
}

resource "kubernetes_manifest" "redis" {
  manifest = {
    "apiVersion" = "monitoring.coreos.com/v1"
    "kind"       = "ServiceMonitor"
    "metadata" = {
      "name"      = "prometheus-redis-exporter"
      "labels" = {
        "app.kubernetes.io/component" = "metrics"
        "app.kubernetes.io/instance" = "monitoring"
        "app.kubernetes.io/name" = "prometheus-redis-exporter"
        "app.kubernetes.io/part-of" = "prometheus-redis-exporter"
      }
      "namespace" = "monitoring"
    }
    "spec" = {
        "endpoints" = [{
            "port" = "redis-exporter"
            "interval" = "30s"
            "scrapeTimeout" = "10s"
        }]
        "namespaceSelector" = {
            "matchNames" = ["*"]
        }
        "selector" = {
            "matchLabels" = {
                "app.kubernetes.io/instance" = "monitoring"
                "app.kubernetes.io/name" = "prometheus-redis-exporter"
                }
        }
    }
  }
}