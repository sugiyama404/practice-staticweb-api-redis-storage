resource "azurerm_static_web_app" "static_web_app" {
  name                = "securedemo-swa"
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location

  app_settings = {
    "BACKEND_URL" = "${var.app_service_url}"
    "NODE_ENV"    = "production"
  }

  tags = {
    environment = "dev"
    purpose     = "secure-webapp"
  }
}
