{ pkgs, config, lib, beads-viewer, ... }:

{
  home.packages = with pkgs; [
    cloc
    ghq
    # gnused

    just

    # font-fira-code

    bash
    zlib

    beads
  ] ++ lib.optionals config.dotfiles.isPersonal [
    beads-viewer
    jq
    awscli2
  ] ++ lib.optionals config.dotfiles.isWork [
    google-cloud-sdk
    uv
    argo-workflows
  ];
}
