{ pkgs, ... }:

{
  home.packages = with pkgs; [ eza ];

  programs.zsh.shellAliases = {
    ls = "eza";
  };
}
