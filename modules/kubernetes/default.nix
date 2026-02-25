{ pkgs, config, lib, ... }:

{
  home.packages = lib.optionals config.dotfiles.isPersonal (with pkgs; [
    kubectl
  ]);

  programs.zsh = {
    shellAliases = {
      k = "kubectl";
    };
  };
}
