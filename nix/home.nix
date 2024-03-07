{ pkgs, ... }:

{
  programs.home-manager.enable = true;

  home = {
    username = "$USER";
    homeDirectory = "/Users/$USER";
    stateVersion = "22.11";
  };

  imports = [
    # nix
    ./nix
    ./direnv

    # commands
    ./bat
    ./eza
    ./ripgrep
    ./ast-grep
    ./fzf

    # shell
    ./starship
    ./zsh

    # editors
    ./vim
    # ./emacs

    # languages
    ./haskell
    # ./purescript
    # ./idris
    # ./ocaml
    ./javascript
    ./java # for alloy
    ./lean

    # others
    ./git
    ./docker
    ./utils
    ./gyazo
    ./warp
    ./karabiner
  ];
}