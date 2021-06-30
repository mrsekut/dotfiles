{ pkgs, ... }:

{
  home.packages = with pkgs; [ idris ];
}
