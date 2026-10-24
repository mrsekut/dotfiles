dotfilesPath := "$HOME/dev/github.com/mrsekut/dotfiles"

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


# flake.lockを更新
flake-update:
  nix flake update

nix-update-apply-personal:
  just flake-update
  just home-manager-apply-personal
  just darwin-apply-personal

nix-update-apply-work:
  just flake-update
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
# agenix (ssh config)
# =================

# 新しいPCで最初に1回。agenix 用の鍵を作り、公開鍵を表示する
# → 表示された公開鍵を modules/ssh/secrets.nix に追加し、既存PCで `just ssh-rekey` して push
agenix-keygen:
  test -f ~/.ssh/agenix_ed25519 || ssh-keygen -t ed25519 -N "" -f ~/.ssh/agenix_ed25519 -C "agenix@$(hostname -s)"
  cat ~/.ssh/agenix_ed25519.pub

# ~/.ssh/config を編集する。保存後に home-manager-apply-* で反映
ssh-edit:
  cd modules/ssh && AGENIX_RULES=secrets.nix nix run github:ryantm/agenix -- -e ssh-config.age -i ~/.ssh/agenix_ed25519

# secrets.nix の公開鍵を変えた後に再暗号化する
ssh-rekey:
  cd modules/ssh && AGENIX_RULES=secrets.nix nix run github:ryantm/agenix -- -r -i ~/.ssh/agenix_ed25519


# =================
# VSCode
# =================

# dotfilesの内容をlocalに適用する
cursor-apply-snippets:
  bash modules/editors/cursor/snippets/index.sh

# dotfilesの内容をlocalに適用する
cursor-apply-extensions:
  bash modules/editors/cursor/extensions/apply.sh

# dotfilesを更新する
cursor-save-extensions-to-dotfiles:
	bash modules/editors/cursor/extensions/save.sh
