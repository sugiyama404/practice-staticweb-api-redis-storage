# App Service Plan
resource "azurerm_service_plan" "app_plan" {
  name                = "securedemo-plan"
  location            = "japanwest"
  resource_group_name = var.resource_group.name
  os_type             = "Linux"
  sku_name            = "S1" # Changed from P1v2 to S1 due to quota limitations
  tags = {
    environment = "dev"
    purpose     = "secure-webapp"
  }
}
