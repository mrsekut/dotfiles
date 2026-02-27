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


# agent-skillsのスキルソースを更新
skills-update:
  nix flake lock --update-input anthropic-skills --update-input intellectronica-skills --update-input sdd-skills --update-input mrsekut-skills


# flake.lockを更新
flake-update:
  nix flake update

nix-apply-personal:
  just home-manager-apply-personal
  just darwin-apply-personal

nix-apply-work:
  just home-manager-apply-work
  just darwin-apply-work

home-manager-apply-personal:
  nix run home-manager -- switch --flake '.#mrsekut@personal'

home-manager-apply-work:
  nix run home-manager -- switch --flake '.#mrsekut@work'

darwin-apply-personal:
  sudo nix run nix-darwin -- switch --flake '.#mrsekut@personal'

darwin-apply-work:
  sudo nix run nix-darwin -- switch --flake '.#mrsekut@work'


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
