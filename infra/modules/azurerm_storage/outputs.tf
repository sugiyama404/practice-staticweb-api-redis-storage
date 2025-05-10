output "storage_main_account_name" {
  value = azurerm_storage_account.storage.name
}

output "storage_main_account_access_key" {
  value = azurerm_storage_account.storage.primary_access_key
}

output "storage_account_main_primary_connection_string" {
  value = azurerm_storage_account.storage.primary_connection_string
}

output "azure_storage_connection_string" {
  description = "Formatted AZURE_STORAGE_CONNECTION_STRING environment variable"
  value       = "DefaultEndpointsProtocol=${startswith(azurerm_storage_account.storage.primary_blob_endpoint, "https") ? "https" : "http"};AccountName=${azurerm_storage_account.storage.name};AccountKey=${azurerm_storage_account.storage.primary_access_key};BlobEndpoint=${azurerm_storage_account.storage.primary_blob_endpoint};"
  sensitive   = true
}
