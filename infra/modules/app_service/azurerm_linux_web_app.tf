# App Service (Backend API)
resource "azurerm_linux_web_app" "api" {
  name                = "securedemo-api${random_string.unique_key.result}"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  service_plan_id     = azurerm_service_plan.app_plan.id

  site_config {
    application_stack {
      docker_image_name        = "${var.image_name}:latest"
      docker_registry_url      = "https://${var.registry_login_server}"
      docker_registry_username = var.registry_admin_username
      docker_registry_password = var.registry_admin_password
    }
  }

  app_settings = {
    "FLASK_DEBUG"                     = "false"
    "FLASK_APP"                       = "app.py"
    "REDIS_HOST"                      = "@Microsoft.KeyVault(SecretUri=https://${var.key_vault.name}.vault.azure.net/secrets/RedisHost/)"
    "REDIS_PORT"                      = var.redis_port
    "AZURE_STORAGE_CONNECTION_STRING" = "@Microsoft.KeyVault(SecretUri=https://${var.key_vault.name}.vault.azure.net/secrets/AzureStorageConnectionString/)"
    "WEBSITES_PORT"                   = "8000"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "dev"
    purpose     = "secure-webapp"
  }
}

resource "random_string" "unique_key" {
  length  = 10
  upper   = false
  lower   = true
  numeric = true
  special = false
}
