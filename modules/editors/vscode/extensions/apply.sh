#!/bin/sh
# dotfiles内のextensionsを正として、localの拡張を上書きする

CURRENT=$(cd "$(dirname "$0")" && pwd)

backup_extensions() {
  TARGET_NAME="$1"
  CMD="$2"
  BACKUP_FILE="$CURRENT/backups/${TARGET_NAME}/extensions"

  mkdir -p "$CURRENT/backups/${TARGET_NAME}"
  $CMD --list-extensions > "$BACKUP_FILE"
  echo "Current $TARGET_NAME extensions backed up."
}

install_missing_extensions() {
  TARGET_NAME="$1"
  CMD="$2"
  EXTENSIONS_FILE="$CURRENT/extensions"
  BACKUP_FILE="$CURRENT/backups/${TARGET_NAME}/extensions"

  comm -23 <(sort "$EXTENSIONS_FILE") <(sort "$BACKUP_FILE") | while read -r extension; do
    if [ -n "$extension" ]; then
      $CMD --install-extension "$extension"
      echo "Installed $extension for $TARGET_NAME"
    fi
  done
}

uninstall_extra_extensions() {
  TARGET_NAME="$1"
  CMD="$2"
  EXTENSIONS_FILE="$CURRENT/extensions"
  BACKUP_FILE="$CURRENT/backups/${TARGET_NAME}/extensions"

  comm -13 <(sort "$EXTENSIONS_FILE") <(sort "$BACKUP_FILE") | while read -r extension; do
    if [ -n "$extension" ]; then
      $CMD --uninstall-extension "$extension"
      echo "Uninstalled $extension for $TARGET_NAME"
    fi
  done
}

# === 実行 ===

# vscode
backup_extensions "vscode" "code"
install_missing_extensions "vscode" "code"
uninstall_extra_extensions "vscode" "code"

# cursor
# backup_extensions "cursor" "cursor"
# install_missing_extensions "cursor" "cursor"
# uninstall_extra_extensions "cursor" "cursor"