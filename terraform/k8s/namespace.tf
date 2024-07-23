resource "kubernetes_namespace" "example" {
    for_each = var.namespace
  metadata {
    name = "${each.key}"
  }
}