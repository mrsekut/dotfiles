{ pkgs, gyou, ... }:

{
  home.packages = with pkgs; [
    cloc
    # jq
    ghq
    # gnused

    just

    # font-fira-code

    bash
    zlib
    # awscli2

    google-cloud-sdk

    uv # `uvx test-opensearch-mcp` したいので一時的に追加
    argo
    gyou
  ];
}
