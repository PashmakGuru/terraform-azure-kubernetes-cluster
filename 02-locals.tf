locals {
  id = "cluster-${var.name}-${var.environment}"
  common_tags = {
    module = "kubernetes-cluster"
    name = var.name
    env = var.environment
  }
}
