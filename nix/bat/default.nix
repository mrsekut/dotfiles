{ config, lib, pkgs, ... }:

with lib;

{
  home.packages = with pkgs; [ bat ];

  programs.zsh.shellAliases = {
    cat = "bat";
  };
}
