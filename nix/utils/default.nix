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

    nodejs
    # yarn

    # rbenv
    # ruby-build

    # php@7.4
    # composer

    # python@3.8
    # python@3.9

    # mysql
    # sqlite

    # awscli
    # docker
    # unison

    ### docker ###
    docker-sync
    docker-compose

    zlib
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
    # webp
    # xorgproto
    # xxhash
    # xz
    # zsh
    # zstd
  ];
}
