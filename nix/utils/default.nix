{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cloc
    jq
    ghq
    httpie
    # gnused

    just

    sqlfluff

    # font-fira-code

    ### languages ###
    # clojure
    # gauche

    # rbenv
    # ruby-build

    # php@7.4
    # composer

    bash
    zlib
    # awscli
    # gawk
    # jpeg
    # node
    # oniguruma
    # six
    # unbound
    # unixodbc
    # unox
  ];
}
