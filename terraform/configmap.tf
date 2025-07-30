resource "kubernetes_config_map" "test" {
  metadata {
    name = "test"
  }

  data = {
    MAX_UPTIME_MINS = var.max_uptime_mins
  }
}