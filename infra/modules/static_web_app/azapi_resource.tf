# Static Web App (azapi リソースを使用して実装)
resource "azapi_resource" "static_web_app" {
  type      = "Microsoft.Web/staticSites@2022-03-01"
  name      = var.static_web_app_name # 変数を使用
  location  = var.resource_group.location
  parent_id = var.resource_group.id

  body = jsonencode({
    properties = {
      stagingEnvironmentPolicy = "Enabled"
      allowConfigFileUpdates   = true
      enterpriseGradeCdnStatus = "Disabled"
      provider                 = "Custom"
    }
    sku = {
      name = "Standard"
      tier = "Standard"
    }
  })

  tags = {
    environment = "dev"
    purpose     = "secure-webapp"
  }
}

# Static Web App のバックエンド API として App Service を設定
resource "azapi_resource" "static_web_app_linked_backend" {
  type      = "Microsoft.Web/staticSites/linkedBackends@2022-03-01"
  name      = "backend1"
  parent_id = azapi_resource.static_web_app.id

  body = jsonencode({
    properties = {
      backendResourceId = var.app_service.id
      region            = var.resource_group.location
    }
  })

  depends_on = []
}

# Static Web App の アプリ設定
resource "azapi_resource" "static_web_app_config" {
  type      = "Microsoft.Web/staticSites/config@2022-03-01"
  name      = "appsettings"
  parent_id = azapi_resource.static_web_app.id

  body = jsonencode({
    properties = {
      "REDIS_CONNECTION_STRING"   = "@Microsoft.KeyVault(SecretUri=https://${var.key_vault.name}.vault.azure.net/secrets/RedisConnectionString/)",
      "STORAGE_CONNECTION_STRING" = "@Microsoft.KeyVault(SecretUri=https://${var.key_vault.name}.vault.azure.net/secrets/StorageConnectionString/)",
      "BACKEND_URL"               = "http://${var.app_service.default_hostname}:8000",
      "NODE_ENV"                  = "production"
    }
  })

  depends_on = []
}
