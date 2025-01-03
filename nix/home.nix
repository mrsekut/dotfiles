{ pkgs, ... }:

{
  programs.home-manager.enable = true;

  home = {
    username = "mrsekut";
    homeDirectory = "/Users/mrsekut";
    stateVersion = "24.11";
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
    # ./java # for alloy
    # ./lean
    ./python
    ./rust

    # others
    ./git
    ./utils
    ./gyazo
    # ./warp
    ./karabiner
  ];
}