{ pkgs, ... }:

{
  imports = [
    ./nix
    ./direnv
    ./devbox
  ];

  home.packages = with pkgs; [
    nixfmt-classic
    nil
    nix-update
  ];
}
