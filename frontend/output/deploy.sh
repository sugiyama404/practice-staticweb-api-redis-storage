#!/usr/bin/env bash

set -euo pipefail

function deploy() {
  cd "/app"

  # Generate timestamp for unique filename
  ZIP_FILENAME="frontend.zip"
  OUTPUT_DIR="/output"

  # Ensure output directory exists
  mkdir -p "${OUTPUT_DIR}"

  # Create zip file from all files in /app and save to output directory
  echo "Creating zip file of /app contents..."
  zip -r "${OUTPUT_DIR}/${ZIP_FILENAME}" .

  echo "Successfully created ${OUTPUT_DIR}/${ZIP_FILENAME}"
}

# メインの処理
function main() {
  deploy
}

# スクリプトが直接実行された場合にメイン関数を呼び出す
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
