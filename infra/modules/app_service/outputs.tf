output "app_service_id" {
  description = "The ID of the App Service"
  value       = azurerm_linux_web_app.api.id
}

output "app_service_hostname" {
  description = "The default hostname of the App Service"
  value       = azurerm_linux_web_app.api.default_hostname
}

output "app_service_name" {
  description = "The name of the App Service"
  value       = azurerm_linux_web_app.api.name
}

output "app_service_url" {
  description = "The complete URL of the App Service"
  value       = "https://${azurerm_linux_web_app.api.default_hostname}"
}

output "app_service_principal_id" {
  value = azurerm_linux_web_app.api.identity[0].principal_id
}
