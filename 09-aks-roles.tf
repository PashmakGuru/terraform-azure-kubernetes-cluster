locals {
  aks_rg_roles = [
    "Network Contributor",
    "Virtual Machine Contributor"
  ]
  aks_nodes_rg_roles = [
    "Network Contributor",
    "Virtual Machine Contributor"
  ]
}

resource "azurerm_role_assignment" "aks_rg_roles" {
  for_each             = toset(local.aks_rg_roles)
  scope                = azurerm_resource_group.this.id
  role_definition_name = each.value
  principal_id         = azurerm_kubernetes_cluster.this.identity[0].principal_id
}

resource "azurerm_role_assignment" "aks_nodes_rg_roles" {
  for_each             = toset(local.aks_nodes_rg_roles)
  scope                = azurerm_kubernetes_cluster.this.node_resource_group_id
  role_definition_name = each.value
  principal_id         = azurerm_kubernetes_cluster.this.identity[0].principal_id
}

