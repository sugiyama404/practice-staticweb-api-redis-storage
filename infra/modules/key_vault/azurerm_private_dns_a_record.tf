resource "azurerm_private_dns_a_record" "kv_dns_record" {
  name                = azurerm_key_vault.kv.name
  zone_name           = azurerm_private_dns_zone.kv_dns.name
  resource_group_name = var.resource_group.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.kv_pe.private_service_connection[0].private_ip_address]
}
