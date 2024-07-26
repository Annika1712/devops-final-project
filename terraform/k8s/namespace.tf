resource "kubernetes_namespace_v1" "this" {
  for_each = var.namespace
  metadata {
    name = each.key
  }
}