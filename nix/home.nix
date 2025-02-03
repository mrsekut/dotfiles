{ pkgs, ... }:

{
  programs.home-manager.enable = true;

  home = {
    username = "mrsekut";
    homeDirectory = "/Users/mrsekut";
    stateVersion = "24.11";
  };

  imports = [
    ./nix
    ./editors
    ./languages

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