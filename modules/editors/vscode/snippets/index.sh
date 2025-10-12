#!/bin/sh

CURRENT=$(cd $(dirname "$0") && pwd)
VSCODE_SNIPPETS_DIR=~/Library/Application\ Support/Code/User/snippets
CURSOR_SNIPPETS_DIR=~/Library/Application\ Support/Cursor/User/snippets
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

backup() {
  TARGET_DIR="$1"
  TARGET_NAME="$2"

  mkdir -p "$TARGET_DIR"
  mkdir -p "$CURRENT/backups/$TARGET_NAME"

  for file in "$CURRENT"/*.json; do
    if [ -f "$file" ]; then
      FILENAME=$(basename "$file")
      TARGET="$TARGET_DIR/$FILENAME"
      BACKUP_FILE="$CURRENT/backups/${TARGET_NAME}/${FILENAME}_${TIMESTAMP}"

      if [ -f "$TARGET" ]; then
        cp "$TARGET" "$BACKUP_FILE"
        echo "$FILENAME: Backup created for $TARGET_NAME"
      fi
    fi
  done
}

create_symlink() {
  TARGET_DIR="$1"

  mkdir -p "$TARGET_DIR"
  for file in "$CURRENT"/*.json; do
    if [ -f "$file" ]; then
      FILENAME=$(basename "$file")
      TARGET="$TARGET_DIR/$FILENAME"

      rm -f "$TARGET"
      ln -s "$file" "$TARGET"
      echo "$FILENAME: Symlink created for $(basename "$TARGET_DIR")"
    fi
  done
}

# backup "$VSCODE_SNIPPETS_DIR" "vscode" && create_symlink "$VSCODE_SNIPPETS_DIR"
backup "$CURSOR_SNIPPETS_DIR" "cursor" && create_symlink "$CURSOR_SNIPPETS_DIR"
