dotfilesPath := "$HOME/Desktop/dev/github.com/mrsekut/dotfiles"

default:
	@just --choose


# nix-env install
# ref https://nixos.org/manual/nix/stable/#sect-macos-installation
nix-install:
	#!/usr/bin/env bash
	mkdir -p ~/.config
	ln -sf {{dotfilesPath}}/nix ~/.config/nixpkgs

	if [[ $(uname -s) == "Darwin" ]]; then
		sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume --no-daemon
	else
		sh <(curl -L https://nixos.org/nix/install) --no-daemon
	fi

	source ~/.nix-profile/etc/profile.d/nix.sh


# home-manager install
home-manager-install:
	#!/usr/bin/env bash
	nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
	nix-channel --update
	nix-shell '<home-manager>' -A install


