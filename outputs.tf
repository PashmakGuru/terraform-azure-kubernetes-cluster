output "resource_group" {
  value     = azurerm_resource_group.this
}

output "kubernetes_cluster" {
  value     = data.azurerm_kubernetes_cluster.this
  sensitive = true
}
