resource "kubernetes_ingress_class_v1" "alb" {
  metadata {
    name = "ingressclass"
  }

  spec {
    controller = "ingress.k8s.aws/alb"
  }
}