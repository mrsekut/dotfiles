{ pkgs, ... }:

{
  programs.home-manager.enable = true;

  home.username = "$USER";
  home.homeDirectory = "/Users/$USER";
  home.stateVersion = "21.11";

  imports = [
    # nix
    ./nix

    # commands
    ./bat
    ./exa
    ./fzf

    # shell
    ./starship
    ./zsh

    # editors
    ./vim
    ./emacs

    # languages
    ./purescript
    ./idris
    # ./haskell

    # others
    ./git
    ./utils
  ];
}