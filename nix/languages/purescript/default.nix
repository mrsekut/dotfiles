{ pkgs, ... }:

{
  home.packages = with pkgs; [
    spago
    purescript
  ];
}
