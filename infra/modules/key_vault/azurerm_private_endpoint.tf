# Key Vault Private Endpoint
resource "azurerm_private_endpoint" "kv_pe" {
  name                = "securedemo-kv-pe"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.pe_subnet.id

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
