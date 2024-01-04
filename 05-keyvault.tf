data "azuread_group" "platform_engineers" {
  display_name     = "platform-engineers"
  security_enabled = true
}

data "azurerm_client_config" "current" {}

resource "random_string" "azurerm_key_vault_name" {
  length  = 13
  lower   = true
  numeric = false
  special = false
  upper   = false
}

resource "azurerm_key_vault" "this" {
  name                        = "vault-${random_string.azurerm_key_vault_name.result}"
  location                    = azurerm_resource_group.this.location
  resource_group_name         = azurerm_resource_group.this.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  enable_rbac_authorization   = true

  sku_name = "standard"
  tags     = local.common_tags
}

resource "azurerm_role_assignment" "kv_allow_current_sp" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "kv_allow_platform_engineers" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azuread_group.platform_engineers.id
}
