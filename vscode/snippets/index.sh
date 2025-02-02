#!/bin/sh

CURRENT=$(cd $(dirname "$0") && pwd)
VSCODE_SNIPPETS_DIR=~/Library/Application\ Support/Code/User/snippets

backup() {
  mkdir -p "$VSCODE_SNIPPETS_DIR"
  for file in "$CURRENT"/*.json; do
    if [ -f "$file" ]; then
      FILENAME=$(basename "$file")
      TARGET="$VSCODE_SNIPPETS_DIR/$FILENAME"
      BACKUP_FILE="$CURRENT/backup_$FILENAME"

      if [ -f "$TARGET" ]; then
        cp "$TARGET" "$BACKUP_FILE"
        echo "$FILENAME: Backup created"
      fi
    fi
  done
}

create_symlink() {
  for file in "$CURRENT"/*.json; do
    if [ -f "$file" ]; then
      FILENAME=$(basename "$file")
      TARGET="$VSCODE_SNIPPETS_DIR/$FILENAME"

      rm -f "$TARGET"
      ln -s "$file" "$TARGET"
      echo "$FILENAME: Symlink created"
    fi
  done
}

backup && create_symlink
