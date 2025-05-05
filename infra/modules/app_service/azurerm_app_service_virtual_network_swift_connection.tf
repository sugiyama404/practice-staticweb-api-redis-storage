# App Service VNet 統合
resource "azurerm_app_service_virtual_network_swift_connection" "vnet_integration" {
  app_service_id = azurerm_linux_web_app.api.id
  subnet_id      = azurerm_subnet.app_subnet.id
}
