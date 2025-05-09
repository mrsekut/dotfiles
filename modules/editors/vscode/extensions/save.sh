#!/bin/sh
# localの拡張一覧をdotfilesに書き込む

CURRENT=$(cd "$(dirname "$0")" && pwd)
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

mkdir -p "$CURRENT/backups/vscode"
code --list-extensions >"$CURRENT/backups/vscode/extensions_${TIMESTAMP}"
echo "✅ Successfully backed up VSCode extensions to: $CURRENT/backups/vscode/extensions_${TIMESTAMP}"

mkdir -p "$CURRENT/backups/cursor"
cursor --list-extensions >"$CURRENT/backups/cursor/extensions_${TIMESTAMP}"
echo "✅ Successfully backed up Cursor extensions to: $CURRENT/backups/cursor/extensions_${TIMESTAMP}"

code --list-extensions >"$CURRENT/extensions"
echo "✅ Successfully saved VSCode extensions to: $CURRENT/extensions"
