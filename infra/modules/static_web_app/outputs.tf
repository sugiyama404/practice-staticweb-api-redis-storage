# アウトプット定義
output "static_web_app_id" {
  value       = azapi_resource.static_web_app.id
  description = "The ID of the Static Web App"
}

output "static_web_app_name" {
  value       = azapi_resource.static_web_app.name
  description = "The name of the Static Web App"
}

output "static_web_app_principal_id" {
  value       = jsondecode(azapi_update_resource.static_web_app_identity.output).identity.principalId
  description = "The Principal ID of the Static Web App's managed identity"
}

# デプロイ用のAPIキーはAPIを使って取得する必要があります
# このモジュールからは直接取得できないため、以下のようなコマンドでAPIキーを取得できます
# az staticwebapp secrets list --name <static_web_app_name> --query "properties.apiKey"
