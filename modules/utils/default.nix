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

    google-cloud-sdk

    uv # `uvx test-opensearch-mcp` したいので一時的に追加
    argo-workflows
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
