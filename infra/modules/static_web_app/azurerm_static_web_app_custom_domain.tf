# App Settings の設定 - リソース名もazurerm_static_web_appに合わせて更新
resource "azurerm_static_web_app_custom_domain" "static_web_app_domain" {
  static_web_app_id = azurerm_static_web_app.static_web_app.id
  domain_name       = azurerm_static_web_app.static_web_app.default_host_name
  validation_type   = "dns-txt-token"
}
