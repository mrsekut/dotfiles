{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cloc
    jq
    ghq
    httpie
    fzf
    # gnu-sed

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
}
