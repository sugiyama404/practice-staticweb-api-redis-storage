resource "azurerm_static_web_app" "static_web_app" {
  name                = "securedemo-swa"
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location

  # システム割り当てマネージド ID を有効化
  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "dev"
    purpose     = "secure-webapp"
  }
}
