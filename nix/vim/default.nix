{ config, pkgs, lib, ... }: {
  imports = [ ./neovim.nix ./vim.nix ];
}