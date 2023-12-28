resource "azurerm_kubernetes_cluster" "this" {
  name                = var.name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  dns_prefix          = var.name

  sku_tier = "Free"
  kubernetes_version = "1.28"
  oidc_issuer_enabled = true
  workload_identity_enabled = true
  node_resource_group = "${azurerm_resource_group.this.name}-nodes"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
    vnet_subnet_id = azurerm_subnet.cluster.id
  }

  linux_profile {
    admin_username = "pashmak"
    ssh_key {
      key_data = data.azurerm_ssh_public_key.admin_ssh_public_key.public_key
    }
  }

  identity {
    type = "SystemAssigned"
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = true
    secret_rotation_interval = "2m"
  }

  tags = local.common_tags
}
