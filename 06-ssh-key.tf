# See: https://learn.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-terraform?tabs=azure-cli

# resource "random_pet" "ssh_key_name" {
#   prefix    = "ssh"
#   separator = ""
# }

resource "azapi_resource" "ssh_public_key" {
  type      = "Microsoft.Compute/sshPublicKeys@2022-11-01"
  name      = "ssh-key-linux-admin"
  location  = azurerm_resource_group.this.location
  parent_id = azurerm_resource_group.this.id

  tags = local.common_tags
}

resource "azapi_resource_action" "ssh_public_key_gen" {
  type        = "Microsoft.Compute/sshPublicKeys@2022-11-01"
  resource_id = azapi_resource.ssh_public_key.id
  action      = "generateKeyPair"
  method      = "POST"
  body = jsonencode({
    encryptionType = "Ed25519"
  })

  response_export_values = ["publicKey", "privateKey"]
}

resource "azurerm_key_vault_secret" "admin_ssh_private_key" {
    depends_on =[ azurerm_role_assignment.kv_allow_current_sp ]
  name         = "admin-ssh-private-key"
  value        = jsondecode(azapi_resource_action.ssh_public_key_gen.output).privateKey
  key_vault_id = azurerm_key_vault.this.id

  tags = local.common_tags
}

data "azurerm_ssh_public_key" "admin_ssh_public_key" {
  depends_on = [ azapi_resource_action.ssh_public_key_gen ]
  name                = "ssh-key-linux-admin"
  resource_group_name = azurerm_resource_group.this.name
}
