# Express.js から Next.js への移行手順

このファイルには、従来の Express.js ベースのフロントエンドから Next.js への移行手順が記載されています。

## 移行の主な変更点

1. **アーキテクチャの変更**
   - Express.js によるサーバーサイドレンダリングから Next.js のハイブリッドレンダリングへ
   - 単一のサーバーファイル（server.js）からページベースのルーティングへ

2. **API の処理方法**
   - Express のミドルウェアからNext.js の API Routes への移行
   - ファイルアップロード処理の変更（multer から formidable へ）

3. **ファイルの配置**
   - 静的ファイルの配置場所は同じく `public/` フォルダ
   - ルーティングは `pages/` ディレクトリのファイル構造で制御

## 開発手順

1. Next.js のインストールとセットアップ
```bash
npm install next react react-dom
```

2. package.json のスクリプトの変更
```json
"scripts": {
  "dev": "next dev",
  "build": "next build",
  "start": "next start"
}
```

3. `.env` ファイルの移行
バックエンド URL の環境変数は同じまま使用可能です。

4. API プロキシの設定
`next.config.js` でリライトルールを設定するか、カスタム API Routes を作成します。

## デプロイ手順

1. ビルド処理
```bash
npm run build
```

2. 出力されたファイルをデプロイ
```bash
zip -r frontend.zip .next package.json next.config.js public
```

3. Azure Static Web Apps へのデプロイ
Azure Static Web Apps CLI または GitHub Actions を使用してデプロイします。
