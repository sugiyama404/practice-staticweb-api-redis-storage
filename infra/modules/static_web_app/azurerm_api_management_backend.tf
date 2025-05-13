# バックエンドリンクを API マネジメントで実装
resource "azurerm_api_management_backend" "backend" {
  name                = "backend1"
  resource_group_name = var.resource_group.name
  api_management_name = azurerm_api_management.api_mgmt.name
  protocol            = "http"
  url                 = "https://${var.app_service_url}"
}
