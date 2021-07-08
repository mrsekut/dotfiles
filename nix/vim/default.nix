{ pkgs, ... }:

{
  programs.git.extraConfig.core.editor = "vim";
  # programs.zsh.sessionVariables.EDITOR = "vim";

  programs.vim = {
    enable = true;
    extraConfig = builtins.readFile ./dot.vimrc;
  };
}
