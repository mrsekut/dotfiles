{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  home.username = "mrsekut";
  home.homeDirectory = "/Users/mrsekut";
  home.stateVersion = "21.11";

  home.packages = with pkgs; [
    bat
    # jq
    # ghq
    # httpie
    # fzf
    # gnu-sed
    # zsh

    # font-fira-code

    # git
    # gh
    # hub

    # julia

    # hlint
    # ghc
    # haskell-stack

    # clojure

    # node

    # rbenv

    # php@7.4
    # composer

    # docker
    # unison
  ];

  programs.zsh = {
    enable = true;
    # autocd = true;
    # enableCompletion = true;
    # enableAutosuggestions = true;
    shellAliases = {
      cdd = "cd $(ghq list --full-path | fzf) && code .";
      cdg = "cd $(ghq list --full-path | fzf)";
      codeg = "ghq list --full-path | fzf | xargs code";

      cat = "bat";
      sed = "gsed";
    };
  };
}
