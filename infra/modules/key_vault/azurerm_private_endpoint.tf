# Key Vault Private Endpoint
resource "azurerm_private_endpoint" "kv_pe" {
  name                = "securedemo-kv-pe"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  subnet_id           = var.subnet_pe_subnet_id

  private_service_connection {
    name                           = "kv-privateserviceconnection"
    private_connection_resource_id = azurerm_key_vault.kv.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }

  tags = {
    environment = "dev"
    purpose     = "secure-webapp"
  }
}
