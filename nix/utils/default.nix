{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cloc
    jq
    ghq
    # gnused

    just

    # font-fira-code

    bash
    zlib
  ];
}
