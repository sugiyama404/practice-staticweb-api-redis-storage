resource "null_resource" "default" {
  provisioner "local-exec" {
    command = "az acr login --name ${var.registry_name}"
  }

  provisioner "local-exec" {
    command = "docker build -t ${var.registry_login_server}/${var.image_name}:latest --file ../apserver/Dockerfile ../apserver/"
  }
  provisioner "local-exec" {
    command = "docker push ${var.registry_login_server}/${var.image_name}:latest"
  }
}


# フロントエンドのビルド、ZIP化、デプロイ
resource "null_resource" "frontend_deployment" {
  # リソースIDが変わったら再実行
  triggers = {
    static_web_app_id = azurerm_static_site.example.id
    # フロントエンドのコードが変更された場合に再デプロイするための仕組み
    code_version = filemd5("${path.module}/frontend/package.json")
  }
