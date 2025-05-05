resource "azurerm_private_dns_a_record" "blob_dns_record" {
  name                = azurerm_storage_account.storage.name
  zone_name           = azurerm_private_dns_zone.blob_dns.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.storage_pe.private_service_connection[0].private_ip_address]
}
