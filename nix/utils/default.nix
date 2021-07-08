{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cloc
    jq
    ghq
    httpie
    gnused

    # font-fira-code

    # julia

    clojure
    # gauche

    # node
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

    # emacs

    # docker
    docker-sync
    docker-compose

    # curl
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
