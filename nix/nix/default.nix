{ pkgs, ... }:

{
  home.packages = with pkgs; [ nix-prefetch-git ];
}
