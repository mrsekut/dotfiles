{ config, pkgs, ... }:

{
  system.stateVersion = 5;

  imports = [
    # <home-manager/nix-darwin>
    ./dock.nix
    ./trackpad.nix
    ./keyboard.nix
    # ./fonts.nix
  ];
}
