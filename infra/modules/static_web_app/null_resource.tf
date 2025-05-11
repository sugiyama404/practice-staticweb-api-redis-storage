# フロントエンドのビルド、ZIP化、デプロイ
resource "null_resource" "frontend_deployment" {
  # リソースIDが変わったら再実行
  triggers = {
    # Static Web AppのIDが変わった場合に再デプロイ
    static_web_app_id = azurerm_static_web_app.static_web_app.id
    # フロントエンドのZIPファイルが変更された場合に再デプロイするためのトリガー
    code_version = filemd5("${path.root}/../frontend/output/frontend.zip")
  }

  # フロントエンドのデプロイ
  provisioner "local-exec" {
    command = <<EOT
      # 既存のfrontend.zipファイルを使用してデプロイ
      az staticwebapp deploy \
        --name ${azurerm_static_web_app.static_web_app.name} \
        --source ${path.root}/../frontend/output/frontend.zip \
        --resource-group ${var.resource_group.name} \
        --login-with-github false
    EOT
  }

  depends_on = [azurerm_static_web_app.static_web_app]
}

# デプロイコマンドのアウトプット
output "deploy_command" {
  value = "az staticwebapp deploy --name ${azurerm_static_web_app.static_web_app.name} --source ${path.root}/../frontend/output/frontend.zip --resource-group ${var.resource_group.name} --login-with-github false"
}


# App 設定を出力として提供 (Static Web Apps の app settings は Terraform でサポートされていないため)
resource "null_resource" "app_settings" {
  triggers = {
    static_web_app_id = azurerm_static_web_app.static_web_app.id
  }

  provisioner "local-exec" {
    command = <<EOT
      az staticwebapp appsettings set \
        --name ${azurerm_static_web_app.static_web_app.name} \
        --resource-group ${var.resource_group.name} \
        --setting-names BACKEND_URL=http://${var.app_service_url} NODE_ENV=production
    EOT
  }

  depends_on = [azurerm_static_web_app.static_web_app]
}
