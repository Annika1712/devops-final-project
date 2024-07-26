resource "kubernetes_storage_class_v1" "ebs" {
  metadata {
    name = "ebs-class"
  }
  storage_provisioner    = "ebs.csi.aws.com"
  reclaim_policy         = "Retain"
  volume_binding_mode    = "WaitForFirstConsumer"
  allow_volume_expansion = true
  parameters = {
    type = "pg3"
  }
}