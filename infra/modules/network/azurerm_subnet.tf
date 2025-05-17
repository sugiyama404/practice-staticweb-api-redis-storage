# App Service 統合用サブネット
resource "azurerm_subnet" "app_subnet" {
  name                 = "app-service-subnet"
  resource_group_name  = var.resource_group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  delegation {
    name = "app-service-delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
  service_endpoints = ["Microsoft.Storage"]
}

# Private Endpoint 用サブネット
resource "azurerm_subnet" "pe_subnet" {
  name                              = "private-endpoint-subnet"
  resource_group_name               = var.resource_group.name
  virtual_network_name              = azurerm_virtual_network.vnet.name
  address_prefixes                  = ["10.0.2.0/24"]
  private_endpoint_network_policies = "Disabled"
}
