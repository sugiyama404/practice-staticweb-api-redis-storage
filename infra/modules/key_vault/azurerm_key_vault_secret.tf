# Redis Host secret
resource "azurerm_key_vault_secret" "redis_host" {
  name         = "RedisHost"
  value        = var.redis_host
  key_vault_id = azurerm_key_vault.kv.id
}

# Redis Port secret
resource "azurerm_key_vault_secret" "redis_port" {
  name         = "RedisPort"
  value        = var.redis_port
  key_vault_id = azurerm_key_vault.kv.id
}

# Azure Storage Connection String secret
resource "azurerm_key_vault_secret" "storage_connection_string" {
  name         = "AzureStorageConnectionString"
  value        = var.storage_connection_string
  key_vault_id = azurerm_key_vault.kv.id
}
