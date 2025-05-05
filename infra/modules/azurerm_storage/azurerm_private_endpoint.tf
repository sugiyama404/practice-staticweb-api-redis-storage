# Storage Account Private Endpoint (Blob)
resource "azurerm_private_endpoint" "storage_pe" {
  name                = "securedemo-storage-pe"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.pe_subnet.id

  private_service_connection {
    name                           = "storage-privateserviceconnection"
    private_connection_resource_id = azurerm_storage_account.storage.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  tags = {
    environment = "dev"
    purpose     = "secure-webapp"
  }
}
