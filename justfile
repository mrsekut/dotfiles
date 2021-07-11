dotfilesPath := "$HOME/Desktop/dev/github.com/mrsekut/dotfiles"

default:
	@just --choose


# nix-env install
nix-install:
	#!/usr/bin/env bash
	mkdir -p ~/.config
	ln -sf ~/dotfiles/nix-home ~/.config/nixpkgs

	if [[ $(uname -s) == "Darwin" ]]; then
		sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume --no-daemon
	else
		sh <(curl -L https://nixos.org/nix/install) --no-daemon
	fi
