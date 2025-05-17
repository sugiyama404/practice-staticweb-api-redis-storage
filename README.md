# 静的ホスティング＋API＋キャッシュの統合Webシステム

<p align="center">
  <img src="sources/azure.png" alt="animated">
</p>

![Git](https://img.shields.io/badge/GIT-E44C30?logo=git&logoColor=white)
![gitignore](https://img.shields.io/badge/gitignore%20io-204ECF?logo=gitignoredotio&logoColor=white)
![Azure](https://img.shields.io/badge/azure-%230072C6.svg?logo=microsoftazure&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?logo=terraform&logoColor=white)
[![Python](https://img.shields.io/badge/Python-3.12-blue.svg?logo=python&logoColor=blue)](https://www.python.org/)
![Commit Msg](https://img.shields.io/badge/Commit%20message-Eg-brightgreen.svg)
![Code Cmnt](https://img.shields.io/badge/code%20comment-Ja-brightgreen.svg)

## システム概要

このリポジトリは、Docker Composeを利用してローカルでAzure Static Web Apps + API + Redis + Azurite環境を構築・検証できるプロジェクトです。

### 主な構成

- **フロントエンド**: Next.js (React)
- **バックエンド**: Flask API
- **キャッシュ**: Redis
- **ストレージ**: Azurite

### バックエンドAPI（ポート: 8000）

- `/health` - 各サービスのヘルスチェック
- `/redis-test` - Redis接続テスト
- `/upload` - Azure Blob Storageへのファイルアップロード

### Redis（ポート: 6379）

- インメモリデータストア
- キャッシュ用途

### Azurite（ポート: 10000）

- ローカルAzureストレージエミュレータ
- Blobストレージエンドポイント

## 起動の流れ

### 1. インフラ構築
`bin/terraform_apply` を実行してインフラを構築します。

### 2. デプロイトークン取得
AzureポータルでStatic Web Appにアクセスし、デプロイトークンを取得します。

### 3. Secrets設定
取得したトークンをGitHubリポジトリのSecretsに設定します（例: `AZURE_STATIC_WEB_APPS_API_TOKEN`）。

### 4. リポジトリへのプッシュ
`git push` でリポジトリにプッシュします。

### 5. 自動デプロイ
GitHub Actionsが自動的にデプロイを実行します。

### 6. 動作確認
デプロイ完了後、Static Web AppのURLにアクセスして動作を確認します。
