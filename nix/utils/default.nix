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
    opam
    # julia

    clojure
    # gauche

    nodejs
    # yarn

    # idris
    # idris2

    # llvm

    # go

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
