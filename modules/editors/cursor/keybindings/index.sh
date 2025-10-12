#!/bin/sh

CURRENT=$(cd "$(dirname "$0")" && pwd)
VSCODE_SETTING_DIR=~/Library/Application\ Support/Code/User
CURSOR_SETTING_DIR=~/Library/Application\ Support/Cursor/User
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

backup() {
  TARGET_DIR="$1"
  TARGET_NAME="$2"
  FILENAME="keybindings.json"
  TARGET="$TARGET_DIR/$FILENAME"
  BACKUP_DIR="$CURRENT/backups/$TARGET_NAME"
  BACKUP_FILE="$BACKUP_DIR/${FILENAME}_${TIMESTAMP}"

  mkdir -p "$BACKUP_DIR"

  if [ -f "$TARGET" ]; then
    cp "$TARGET" "$BACKUP_FILE"
    echo "$FILENAME: Backup created for $TARGET_NAME"
  fi
}

create_symlink() {
  TARGET_DIR="$1"
  FILENAME="keybindings.json"
  TARGET="$TARGET_DIR/$FILENAME"
  SOURCE="$CURRENT/$FILENAME"

  mkdir -p "$TARGET_DIR"
  rm -f "$TARGET"
  ln -s "$SOURCE" "$TARGET"
  echo "$FILENAME: Symlink created for $(basename "$TARGET_DIR")"
}

# backup "$VSCODE_SETTING_DIR" "vscode" && create_symlink "$VSCODE_SETTING_DIR"
backup "$CURSOR_SETTING_DIR" "cursor" && create_symlink "$CURSOR_SETTING_DIR"
