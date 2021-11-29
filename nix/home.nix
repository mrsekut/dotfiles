{ pkgs, ... }:

{
  programs.home-manager.enable = true;

  home = {
    username = "$USER";
    homeDirectory = "/Users/$USER";
    stateVersion = "21.11";
  };

  imports = [
    # nix
    ./nix

    # commands
    ./bat
    ./exa
    ./ripgrep
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
    ./ocaml
    ./javascript
    # ./haskell

    # others
    ./git
    ./utils
  ];
}