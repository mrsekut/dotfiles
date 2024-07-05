#!/bin/sh
CURRENT=$(cd $(dirname $0) && pwd)
VSCODE_SETTING_DIR=~/Library/Application\ Support/Code/User
BACKUP_FILE="$CURRENT/backup_keybindings.json"

backup() {
  if [ -f "$VSCODE_SETTING_DIR/keybindings.json" ]; then
    cp "$VSCODE_SETTING_DIR/keybindings.json" "$BACKUP_FILE"
    echo "keybindings: Backup created"
  fi
}

create_symlink() {
  rm -f "$VSCODE_SETTING_DIR/keybindings.json"
  ln -s "$CURRENT/keybindings.json" "$VSCODE_SETTING_DIR/keybindings.json"
  echo "keybindings: Symlink created"
}

backup && create_symlink