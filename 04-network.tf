resource "azurerm_virtual_network" "this" {
  name                = "vnet-main"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  tags = local.common_tags
}

resource "azurerm_subnet" "cluster" {
  name                 = "cluster-subnet"
  address_prefixes     = ["10.1.0.0/24"]
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
}
