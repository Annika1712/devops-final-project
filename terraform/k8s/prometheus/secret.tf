resource "kubernetes_secret_v1" "mongo_redis" {
  metadata {
    name      = "backend-secrets"
    namespace = "monitoring"
  }

  data = {
    redis-service-password = "c29tZXJlZGlzcGFzc3dvcmQ="
    redis-service-host     = "cmVkaXMtc2VydmljZQ=="
    redis-service-port     = "NjM3OQ=="
    mongodb-uri            = "bW9uZ29kYjovL3Jvb3Q6ZXhhbXBsZUBtb25nb2RiLXNlcnZpY2U6MjcwMTc="
  }


  type = "Opaque"
}