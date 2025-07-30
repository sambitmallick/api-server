resource "kubernetes_secret" "test" {
  metadata{
    name = "test"
  }

  data = {
    DUMMY_USERNAME = base64encode(var.dummy_username)
    DUMMY_PASSWORD = base64encode(var.dummy_password)
  }

  type = "Opaque"
  
}