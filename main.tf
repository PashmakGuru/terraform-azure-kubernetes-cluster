terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.79.0"
    }
  }
}

locals {
  id = "${var.name}-${var.environment}"
  common_tags = {
    type = "aks"
    name = var.name
    environment = var.environment
  }
}

resource "azurerm_resource_group" "main" {
  name     = "rg_kubernetes-cluster_${local.id}"
  location = var.location
}

resource "azurerm_kubernetes_cluster" "main" {
  name                = local.id
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = local.id

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = local.common_tags
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.main.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.main.kube_config_raw

  sensitive = true
}
