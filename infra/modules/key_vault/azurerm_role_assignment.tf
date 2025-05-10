# App Service に Key Vault Secrets User ロールを付与
resource "azurerm_role_assignment" "kv_role" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.app_service_principal_id
}
