resource "azurerm_resource_group" "this" {
  name     = "${local.id}"
  location = var.location
  tags = local.common_tags
}