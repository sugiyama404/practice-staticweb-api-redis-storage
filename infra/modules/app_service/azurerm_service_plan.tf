# App Service Plan
resource "azurerm_service_plan" "app_plan" {
  name                = "securedemo-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "P1v2"
  tags = {
    environment = "dev"
    purpose     = "secure-webapp"
  }
}
