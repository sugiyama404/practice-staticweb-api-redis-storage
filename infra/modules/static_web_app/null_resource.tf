# フロントエンドのビルド、ZIP化、デプロイ
resource "null_resource" "frontend_deployment" {
  # リソースIDが変わったら再実行
  triggers = {
    # Static Web AppのIDが変わった場合に再デプロイ
    static_web_app_id = azapi_resource.static_web_app.id
    # フロントエンドのコードが変更された場合に再デプロイするためのトリガー
    code_version = filemd5("${path.root}/../../frontend/package.json")
  }

  # フロントエンドのビルドとZIP化
  provisioner "local-exec" {
    command = <<EOT
      # フロントエンドディレクトリに移動
      cd ${path.root}/../../frontend

      # 必要に応じてビルド（本番用ビルドがある場合）
      npm install

      # 静的ファイルをZIP化（/publicディレクトリの内容）
      cd public
      zip -r ../../frontend.zip *

      # Static Web Appにデプロイ
      az staticwebapp deploy \
        --name ${azapi_resource.static_web_app.name} \
        --source ../../frontend.zip \
        --resource-group ${split("/", azapi_resource.static_web_app.parent_id)[4]} \
        --login-with-github false
    EOT
  }

  depends_on = [azapi_resource.static_web_app, azapi_update_resource.static_web_app_identity]
}

# デプロイコマンドのアウトプット
output "deploy_command" {
  value = "cd ${path.root}/../../frontend && npm install && cd public && zip -r ../../frontend.zip * && az staticwebapp deploy --name ${azapi_resource.static_web_app.name} --source ../../frontend.zip --resource-group ${split("/", azapi_resource.static_web_app.parent_id)[4]} --login-with-github false"
}
