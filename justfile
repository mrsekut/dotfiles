dotfilesPath := "$HOME/Desktop/dev/github.com/mrsekut/dotfiles"

default:
  @just --choose


# nix-env install
# ref https://nixos.org/manual/nix/stable/#sect-macos-installation
nix-install:
  #!/usr/bin/env bash
  mkdir -p ~/.config
  ln -sf {{dotfilesPath}}/nix ~/.config/nixpkgs

  # mac
  sh <(curl -L https://nixos.org/nix/install)

  source ~/.nix-profile/etc/profile.d/nix.sh


nix-uninstall:
  @echo ref https://github.com/NixOS/nix/issues/1402#issuecomment-312496360
  # rm -rf $HOME/{.nix-channels,.nix-defexpr,.nix-profile,.config/nixpkgs}
  # sudo rm -rf /nix



home-manager-install:
  #!/usr/bin/env bash
  nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
  nix-channel --update
  export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
  nix-shell '<home-manager>' -A install


home-manager-apply:
  #!/usr/bin/env bash
  home-manager switch -I localconfig=$HOME/dotfiles/nix-home/machine/$(hostname).nix


home-manager-uninstall:
  #!/usr/bin/env bash
  home-manager uninstall



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



