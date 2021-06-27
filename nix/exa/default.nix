{ config, lib, pkgs, ... }:

with lib;

{
  home.packages = with pkgs; [ exa ];

  programs.zsh.shellAliases = {
    ls = "exa";
  };
}
