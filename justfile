dotfilesPath := "$HOME/Desktop/dev/github.com/mrsekut/dotfiles"

default:
  @just --choose


# =================
# Nix
# =================

# install nix by Determine Nix Installer
# https://zero-to-nix.com/concepts/nix-installer#using
nix-install:
  #!/usr/bin/env bash
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install


nix-uninstall:
  /nix/nix-installer uninstall


nix-apply:
  just home-manager-apply
  just darwin-apply


home-manager-apply:
  nix run home-manager -- switch --flake .#mrsekut

darwin-apply:
  sudo nix run nix-darwin -- switch --flake .#mrsekut


# =================
# VSCode
# =================

# vscodeのaliasを貼る (初回のみ)
vscode-init:
  bash modules/editors/vscode/snippets/index.sh
  bash modules/editors/vscode/settings/index.sh

# dotfilesの内容をlocalに適用する
vscode-apply-snippets:
  bash modules/editors/vscode/snippets/index.sh

# dotfilesの内容をlocalに適用する
vscode-apply-extensions:
  bash modules/editors/vscode/extensions/apply.sh

# dotfilesを更新する
vscode-save-extensions-to-dotfiles:
	bash modules/editors/vscode/extensions/save.sh
