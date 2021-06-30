{ pkgs, ... }:

{
  home.packages = with pkgs; [ exa ];

  programs.zsh.shellAliases = {
    ls = "exa";
  };
}
