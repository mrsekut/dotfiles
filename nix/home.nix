{ config, pkgs, ... }:

let
  allDirs = path: map (d: ./. + "/${d}") (builtins.attrNames (builtins.readDir path));

in
{
  programs.home-manager.enable = true;

  home.username = "mrsekut";
  home.homeDirectory = "/Users/mrsekut";
  home.stateVersion = "21.11";

  imports = builtins.filter (p: p != ./. + "/home.nix") (allDirs ./.);
}