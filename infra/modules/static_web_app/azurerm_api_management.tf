resource "azurerm_api_management" "api_mgmt" {
  name                = "securedemo-apim-${random_string.suffix.result}"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  publisher_name      = "Secure Demo"
  publisher_email     = "admin@example.com"
  sku_name            = "Consumption_0"
}

# ランダム文字列を生成するリソースを追加する場合
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}
