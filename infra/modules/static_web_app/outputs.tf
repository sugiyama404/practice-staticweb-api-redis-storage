# アウトプット定義
output "static_web_app_id" {
  value = azurerm_static_web_app.static_web_app.id
}

output "static_web_app_name" {
  value = azurerm_static_web_app.static_web_app.name
}

output "static_web_app_default_host_name" {
  value = azurerm_static_web_app.static_web_app.default_host_name
}

output "static_web_app_api_key" {
  value     = azurerm_static_web_app.static_web_app.api_key
  sensitive = true
}

output "principal_id" {
  value = azurerm_static_web_app.static_web_app.identity[0].principal_id
}
