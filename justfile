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
  just skills-lock
  just home-manager-apply
  just darwin-apply


# agent-skillsのchild flakeをlock
skills-lock:
  cd modules/agent-skills && nix flake lock


# agent-skillsのスキルソースを更新
skills-update:
  cd modules/agent-skills && nix flake update
  nix flake lock --update-input skills-config


# flake.lockを更新
flake-update:
  nix flake update


home-manager-apply:
  nix run home-manager -- switch --flake .#mrsekut

darwin-apply:
  sudo nix run nix-darwin -- switch --flake .#mrsekut


# =================
# VSCode
# =================

# cursorのaliasを貼る (初回のみ)
cursor-init:
  bash modules/editors/cursor/keybindings/index.sh
  bash modules/editors/cursor/settings/index.sh

# dotfilesの内容をlocalに適用する
cursor-apply-snippets:
  bash modules/editors/cursor/snippets/index.sh

# dotfilesの内容をlocalに適用する
cursor-apply-extensions:
  bash modules/editors/cursor/extensions/apply.sh

# dotfilesを更新する
cursor-save-extensions-to-dotfiles:
	bash modules/editors/cursor/extensions/save.sh
