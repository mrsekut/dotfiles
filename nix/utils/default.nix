{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cloc
    jq
    ghq
    httpie
    # gnu-sed

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

    # apr
    # apr-util
    # argon2
    # aspell
    # autoconf
    # bdw-gc
    # bluetoothconnector
    # brotli
    # c-ares
    # cairo
    # chezscheme
    # contentful-cli
    # curl
    # exercism
    # fontconfig
    # freetds
    # freetype
    # fribidi
    # fswatch
    # gawk
    # gd
    # gdbm
    # gdk-pixbuf
    # gettext
    # glib
    # gmp
    # gnu-sed
    # gnutls
    # gobject-introspection
    # graphite2
    # gts
    # guile
    # harfbuzz
    # icu4c
    # iproute2mac
    # jansson
    # jasper
    # jemalloc
    # jpeg
    # krb5
    # libev
    # libevent
    # libffi
    # libidn2
    # libmetalink
    # libpng
    # libpq
    # libpthread-stubs
    # librsvg
    # libsodium
    # libssh2
    # libtasn1
    # libtiff
    # libtool
    # libunistring
    # libx11
    # libxau
    # libxcb
    # libxdmcp
    # libxext
    # libxrender
    # libzip
    # lz4
    # lzo
    # m4
    # mbedtls
    # mpdecimal
    # mpfr
    # ncurses
    # netpbm
    # nettle
    # nghttp2
    # node
    # oniguruma
    # openjdk
    # openldap
    # openssl@1.1
    # p11-kit
    # pango
    # pcre
    # pcre2
    # php@7.4
    # pixman
    # pkg-config
    # protobuf
    # rbenv
    # readline
    # rlwrap
    # rtmpdump
    # six
    # tcl-tk
    # tidy-html5
    # translate-shell
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
