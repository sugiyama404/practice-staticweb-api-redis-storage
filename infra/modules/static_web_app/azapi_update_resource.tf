# Static Web App に対するシステム割り当てマネージド ID を作成
resource "azapi_update_resource" "static_web_app_identity" {
  type        = "Microsoft.Web/staticSites@2022-03-01"
  resource_id = azapi_resource.static_web_app.id

  body = jsonencode({
    identity = {
      type = "SystemAssigned"
    }
  })
}
