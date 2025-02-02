
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    rye
  ];
}
