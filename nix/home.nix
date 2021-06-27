{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  home.username = "mrsekut";
  home.homeDirectory = "/Users/mrsekut";
  home.stateVersion = "21.11";

  # FIXME: ここにいちいち追記するのめんどい
  imports = [
    ./bat
    ./exa
    ./starship
    ./zsh
  ];

  # home.packages = with pkgs; [
  #   cloc

  #   # jq
  #   # ghq
  #   # httpie
  #   # fzf
  #   # gnu-sed

  #   # font-fira-code

  #   # git
  #   # gh
  #   # hub

  #   # julia

  #   # hlint
  #   # ghc
  #   # haskell-stack

  #   # clojure

  #   # node

  #   # rbenv

  #   # php@7.4
  #   # composer

  #   # docker
  #   # unison
  # ];

}