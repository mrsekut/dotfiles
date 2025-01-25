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

nix-darwin-install:
	#!/usr/bin/env bash
	mkdir -p $HOME/.nixpkgs
	ln -s {{dotfilesPath}}/nix-darwin/darwin-configuration.nix $HOME/.nixpkgs/darwin-configuration.nix
	nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
	./result/bin/darwin-installer


nix-darwin-apply:
	#!/usr/bin/env bash
	darwin-rebuild switch


nix-darwin-update:
	#!/usr/bin/env bash
	nix-channel --update darwin
	darwin-rebuild changelog




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
