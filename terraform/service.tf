resource "kubernetes_service" "test" {
  metadata {
    name = "test"
  }

  spec {
    selector = {
        app = "test"
    }

    port {
        port = 80
        target_port = 8080
    }

    type = "NodePort"
  }
}