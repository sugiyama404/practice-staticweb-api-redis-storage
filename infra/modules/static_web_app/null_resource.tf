# フロントエンドのビルド、ZIP化、デプロイ
resource "null_resource" "frontend_deployment" {
  # リソースIDが変わったら再実行
  triggers = {
    # Static Web AppのIDが変わった場合に再デプロイ
    static_web_app_id = azurerm_static_web_app.static_web_app.id
    # フロントエンドのコードが変更された場合に再デプロイするためのトリガー
    code_version = filemd5("${path.root}/../frontend/package.json")
  }

  # フロントエンドのビルドとZIP化
  provisioner "local-exec" {
    command = <<EOT
      # フロントエンドディレクトリに移動
      cd ${path.root}/../frontend

      # 必要に応じてビルド（本番用ビルドがある場合）
      npm install

      # 静的ファイルをZIP化（/publicディレクトリの内容）
      cd public
      zip -r ../../frontend.zip *

      # Static Web Appにデプロイ
      az staticwebapp deploy \
        --name ${azurerm_static_web_app.static_web_app.name} \
        --source ../../frontend.zip \
        --resource-group ${var.resource_group.name} \
        --login-with-github false
    EOT
  }

  depends_on = [azurerm_static_web_app.static_web_app]
}

# デプロイコマンドのアウトプット
output "deploy_command" {
  value = "cd ${path.root}/../frontend && npm install && cd public && zip -r ../../frontend.zip * && az staticwebapp deploy --name ${azurerm_static_web_app.static_web_app.name} --source ../../frontend.zip --resource-group ${var.resource_group.name} --login-with-github false"
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
