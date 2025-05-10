resource "azurerm_api_management" "api_mgmt" {
  name                = "securedemo-apim"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  publisher_name      = "Secure Demo"
  publisher_email     = "admin@example.com"
  sku_name            = "Consumption_0"
}
