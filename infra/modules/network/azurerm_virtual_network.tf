# 仮想ネットワーク
resource "azurerm_virtual_network" "vnet" {
  name                = "securedemo-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  tags = {
    environment = "dev"
    purpose     = "secure-webapp"
  }
}
