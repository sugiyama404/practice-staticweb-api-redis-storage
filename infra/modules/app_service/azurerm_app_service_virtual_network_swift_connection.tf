# App Service VNet 統合
resource "azurerm_app_service_virtual_network_swift_connection" "vnet_integration" {
  app_service_id = azurerm_linux_web_app.api.id
  subnet_id      = var.subnet_app_subnet_id
}
