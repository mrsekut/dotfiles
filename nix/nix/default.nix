{ pkgs, ... }:

{
  imports = [
    ./nix
    ./direnv
    ./devbox
  ];
}