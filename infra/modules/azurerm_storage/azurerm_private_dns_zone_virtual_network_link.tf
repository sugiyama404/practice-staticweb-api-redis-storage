resource "azurerm_private_dns_zone_virtual_network_link" "blob_dns_link" {
  name                  = "blobdnslink"
  resource_group_name   = var.resource_group.name
  private_dns_zone_name = azurerm_private_dns_zone.blob_dns.name
  virtual_network_id    = var.virtual_network_vnet_id
}
