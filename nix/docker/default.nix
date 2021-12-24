{ pkgs, ... }:

{
  home.packages = with pkgs; [
    docker
    docker-sync
    docker-compose
    # unison
  ];
}
