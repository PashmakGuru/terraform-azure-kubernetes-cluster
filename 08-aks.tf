resource "azurerm_kubernetes_cluster" "this" {
  name                = local.id
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  dns_prefix          = local.id

  sku_tier = "Free"
  kubernetes_version = "1.28"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
    vnet_subnet_id = azurerm_subnet.cluster.id
  }

  identity {
    type = "SystemAssigned"
  }

  tags = local.common_tags
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