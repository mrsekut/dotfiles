{ config, pkgs, ... }:

{
  imports = [
    <home-manager/nix-darwin>
    ./dock.nix
    ./trackpad.nix
    ./keyboard.nix
    ./fonts.nix
  ];
}
