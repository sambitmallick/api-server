resource "kubernetes_deployment" "test" {
  metadata {
    name = "test"
  }
  
  spec {
    replicas = 1

    selector {
        match_labels = {
            app = "test"
        }
    }

    template {
        metadata {
            labels = {
                app = "test"
            }
        }

        spec {
            container {
                image = "api-webserver:latest"
                name = "api-webserver"

                env {
                    name = "DUMMY_USERNAME"
                    value_from {
                        secret_key_ref {
                            name = kubernetes_secret.test.metadata[0].name
                            key = "DUMMY_USERNAME"
                        }
                    }
                }

                env {
                    name = "DUMMY_PASSWORD"
                    value_from {
                        secret_key_ref {
                            name = kubernetes_secret.test.metadata[0].name
                            key = "DUMMY_PASSWORD"
                        }
                    }
                }

                env {
                    name = "MAX_UPTIME_MINS"
                    value_from {
                        config_map_key_ref {
                            name = kubernetes_config_map.test.metadata[0].name
                            key = "MAX_UPTIME_MINS"
                        }
                    }
                }

                port {
                    container_port = 8080
                }

                readiness_probe {
                    http_get {
                        path = "/api/health"
                        port = 8080
                    }
                    initial_delay_seconds = 5
                    period_seconds = 10
                }

                liveness_probe {
                    http_get {
                        path = "/api/health"
                        port = 8080
                    }
                    initial_delay_seconds = 15
                    period_seconds = 20
                }
            }
        }
    }
  }

}