{ pkgs, ... }:

{
  home.packages = with pkgs; [ bat ];

  programs.zsh.shellAliases = {
    cat = "bat";
  };
}
