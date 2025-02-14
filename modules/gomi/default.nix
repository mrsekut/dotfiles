{ pkgs, ... }:

{
  home.packages = with pkgs; [ gomi ];

  programs.zsh = {
    shellAliases = {
      rm = "gomi";
    };
  };
}
