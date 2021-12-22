{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cloc
    jq
    ghq
    httpie
    gnused

    just

    sqlfluff

    # font-fira-code

    ### languages ###
    clojure
    # gauche

    # rbenv
    # ruby-build

    # php@7.4
    # composer

    ### docker ###
    # docker
    docker-sync
    docker-compose
    # unison

    zlib
    # awscli
    # gawk
    # jpeg
    # node
    # oniguruma
    # php@7.4
    # rbenv
    # six
    # unbound
    # unixodbc
    # unox
  ];
}
