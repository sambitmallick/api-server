provider "kubernetes" {
    config_path = "~/.kube/config"
}

terraform {
  required_providers {
    kubernetes = {
        source = "hashicorp/kubernetes"
    }
  }

  backend "local" {
    path = "terraform.tfstate"
  }
}
