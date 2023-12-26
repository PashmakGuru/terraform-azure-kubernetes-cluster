locals {
  common_tags = {
    module = "kubernetes-cluster"
    name = var.name
    environment = var.environment
  }
}
