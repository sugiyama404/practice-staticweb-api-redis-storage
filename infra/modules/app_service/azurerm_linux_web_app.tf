# App Service (Backend API)
resource "azurerm_linux_web_app" "api" {
  name                = "securedemo-api"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.app_plan.id

  site_config {
    application_stack {
      python_version = "3.10"
    }
    always_on = true
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "dev"
    purpose     = "secure-webapp"
  }
}
