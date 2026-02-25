{ pkgs, config, lib, gyou, ... }:

{
  home.packages = with pkgs; [
    cloc
    ghq
    # gnused

    just

    # font-fira-code

    bash
    zlib

    gyou
  ] ++ lib.optionals config.dotfiles.isPersonal [
    jq
    awscli2
  ] ++ lib.optionals config.dotfiles.isWork [
    google-cloud-sdk
    uv
    argo-workflows
  ];
}
