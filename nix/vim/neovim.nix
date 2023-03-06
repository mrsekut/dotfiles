{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    extraConfig = builtins.readFile ./dot.vimrc;
  };
}