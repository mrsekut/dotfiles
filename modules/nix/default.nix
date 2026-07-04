{ pkgs, ... }:

{
  imports = [
    ./nix
    ./direnv
    ./devbox
  ];

  # nix-index-database (for comma)
  programs.nix-index-database.comma.enable = true;

  home.packages = with pkgs; [
    nixfmt
    nil
    nix-update
  ];
}
