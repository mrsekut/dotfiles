{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  home.username = "mrsekut";
  home.homeDirectory = "/Users/mrsekut";
  home.stateVersion = "21.11";

  home.packages = with pkgs; [
    bat
    exa
    cloc
    starship

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
    # TODO: この辺の意味
    autocd = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    shellAliases = {
      cdd = "cd $(ghq list --full-path | fzf) && code .";
      cdg = "cd $(ghq list --full-path | fzf)";
      codeg = "ghq list --full-path | fzf | xargs code";

      ls = "exa";
      cat = "bat";
      sed = "gsed";
    };
    enable = true;
    # plugins = [
    #   {
    #     name = "fast-syntax-highlighting";
    #     src = pkgs.zsh-fast-syntax-highlighting.src;
    #   }
    #   {
    #     name = "history-search-multi-word";
    #     src = pkgs.fetchFromGitHub {
    #       owner = "zdharma";
    #       repo = "history-search-multi-word";
    #       rev = "v1.2.52";
    #       sha256 = "1dqwkw3cwvmmmaczs7vrh3wgrxhc9s2vbyn56nk9rc3561s0s9w7";
    #     };
    #   }
    #   {
    #     name = "zsh-completions";
    #     src = pkgs.zsh-completions.src;
    #   }
    #   {
    #     name = "nix-zsh-completions";
    #     src = pkgs.nix-zsh-completions.src;
    #   }
    # ];
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      character = {
        success_symbol = "λ";
      };
    };
  };
}