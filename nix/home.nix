{ pkgs, ... }:

{
  programs.home-manager.enable = true;

  home = {
    username = "mrsekut";
    homeDirectory = "/Users/mrsekut";
    stateVersion = "24.11";
  };

  imports = [
    ./editors
    ./languages

    # nix
    ./nix
    ./direnv
    ./devbox

    # commands
    ./bat
    ./eza
    ./ripgrep
    ./ast-grep
    ./fzf

    # shell
    ./starship
    ./zsh


    # others
    ./git
    ./utils
    ./gyazo
    ./warp
    ./karabiner
  ];
}