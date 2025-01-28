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
	home-manager switch --flake .#mrsekut



# =================
# Nix Darwin
# =================

nix-darwin-apply:
  nix run nix-darwin -- switch --flake .#mrsekut-darwin


# =================
# VSCode
# =================

# dotfilesの内容をlocalに適用する
vscode-apply:
	bash vscode/settings/index.sh
	bash vscode/keybindings/index.sh
	bash vscode/extensions/apply.sh


# localの内容をdotfilesに適用する
vscode-save:
	bash vscode/extensions/save.sh
