{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;

    autocd = true;
    enableCompletion = true;
    enableAutosuggestions = true;
  };
}
