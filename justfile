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
  export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
  nix-shell '<home-manager>' -A install


# home-manager apply
home-manager:
  #!/usr/bin/env bash
  home-manager switch -I localconfig=$HOME/dotfiles/nix-home/machine/$(hostname).nix


home-manager-uninstall:
  #!/usr/bin/env bash
  home-manager uninstall


nix-uninstall:
  @echo ref https://github.com/NixOS/nix/issues/1402#issuecomment-312496360
  # rm -rf $HOME/{.nix-channels,.nix-defexpr,.nix-profile,.config/nixpkgs}
  # sudo rm -rf /nix





