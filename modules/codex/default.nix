{ pkgs, config, lib, ... }:

{
  home.packages = lib.optionals config.dotfiles.isPersonal [
    pkgs.codex
  ];
}
