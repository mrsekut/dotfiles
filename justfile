dotfilesPath := "$HOME/Desktop/dev/github.com/mrsekut/dotfiles"

default:
  @just --choose


# install nix by Determine Nix Installer
nix-install:
  #!/usr/bin/env bash
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install


nix-uninstall:
  /nix/nix-installer uninstall


nix-apply:
  nix run . switch
	ln -s $HOME/Desktop/dev/github.com/mrsekut/dotfiles/nix/home.nix $HOME/.config/home-manager/home.nix # できればこれなしでやりたい


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



