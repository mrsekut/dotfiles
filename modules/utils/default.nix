{ pkgs, gyou, ... }:

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
    awscli2

    gyou
  ];
}
