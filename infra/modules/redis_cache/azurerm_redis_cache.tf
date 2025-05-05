# Redis Cache
resource "azurerm_redis_cache" "redis" {
  name                          = "securedemo-redis"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  capacity                      = 1
  family                        = "C"
  sku_name                      = "Basic"
  enable_non_ssl_port           = false
  public_network_access_enabled = false

  tags = {
    environment = "dev"
    purpose     = "secure-webapp"
  }
}
