resource "azurerm_private_dns_zone_virtual_network_link" "blob_dns_link" {
  name                  = "blobdnslink"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.blob_dns.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}
