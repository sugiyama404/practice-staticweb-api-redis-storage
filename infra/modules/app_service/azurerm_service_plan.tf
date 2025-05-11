# App Service Plan
resource "azurerm_service_plan" "app_plan" {
  name                = "securedemo-plan"
  location            = "japanwest" # リージョンを変更（例：Japan Westに変更）
  resource_group_name = var.resource_group.name
  os_type             = "Linux"
  sku_name            = "P1v2" # または "S1" など、別のSKUに変更
  tags = {
    environment = "dev"
    purpose     = "secure-webapp"
  }
}
