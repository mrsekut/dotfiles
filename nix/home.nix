{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  home.username = "mrsekut";
  home.homeDirectory = "/Users/mrsekut";
  home.stateVersion = "21.11";

  imports = [
    ./bat
    ./exa
    ./fzf

    ./starship
    ./zsh

    ./utils
  ];
}