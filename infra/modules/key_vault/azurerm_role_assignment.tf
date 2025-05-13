# App Service に Key Vault Secrets User ロールを付与
resource "azurerm_role_assignment" "kv_role" {
  count                = var.create_role_assignment ? 1 : 0
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.app_service_principal_id
}
