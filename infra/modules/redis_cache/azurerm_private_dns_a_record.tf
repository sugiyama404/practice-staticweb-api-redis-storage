resource "azurerm_private_dns_a_record" "redis_dns_record" {
  name                = azurerm_redis_cache.redis.name
  zone_name           = azurerm_private_dns_zone.redis_dns.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.redis_pe.private_service_connection[0].private_ip_address]
}
