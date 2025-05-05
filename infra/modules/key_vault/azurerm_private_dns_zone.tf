# Private DNS Zone for Key Vault
resource "azurerm_private_dns_zone" "kv_dns" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.resource_group.name

  tags = {
    environment = "dev"
    purpose     = "secure-webapp"
  }
}
