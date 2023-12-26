resource "azurerm_kubernetes_cluster" "this" {
  name                = var.name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  dns_prefix          = var.name

  sku_tier = "Free"
  kubernetes_version = "1.28"
  oidc_issuer_enabled = true
  workload_identity_enabled = true

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

resource "azurerm_role_assignment" "kv_allow_aks" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_kubernetes_cluster.this.identity[0].principal_id
}

resource "azurerm_key_vault_secret" "aks_kube_config" {
  name         = "kube-config"
  value        = azurerm_kubernetes_cluster.this.kube_config_raw
  key_vault_id = azurerm_key_vault.this.id

  tags = local.common_tags
}

resource "azurerm_key_vault_secret" "aks_client_certificate" {
  name         = "client-certificate"
  value        = azurerm_kubernetes_cluster.this.kube_config.0.client_certificate
  key_vault_id = azurerm_key_vault.this.id

  tags = local.common_tags
}

resource "azurerm_key_vault_secret" "aks_client_key" {
  name         = "client-key"
  value        = azurerm_kubernetes_cluster.this.kube_config.0.client_key
  key_vault_id = azurerm_key_vault.this.id

  tags = local.common_tags
}

resource "azurerm_key_vault_secret" "aks_cluster_ca_certificate" {
  name         = "cluster-ca-certificate"
  value        = azurerm_kubernetes_cluster.this.kube_config.0.cluster_ca_certificate
  key_vault_id = azurerm_key_vault.this.id

  tags = local.common_tags
}