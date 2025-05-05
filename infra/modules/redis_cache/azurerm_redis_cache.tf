# Redis Cache
resource "azurerm_redis_cache" "redis" {
  name                          = "securedemo-redis"
  location                      = var.resource_group.location
  resource_group_name           = var.resource_group.name
  capacity                      = 1
  family                        = "C"
  sku_name                      = "Basic"
  non_ssl_port_enabled          = false
  public_network_access_enabled = false

  tags = {
    environment = "dev"
    purpose     = "secure-webapp"
  }
}
