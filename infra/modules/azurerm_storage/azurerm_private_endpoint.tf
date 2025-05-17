resource "azurerm_private_endpoint" "storage_pe" {
  name                = "securedemo-storage-pe"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  subnet_id           = var.subnet_pe_subnet_id

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
