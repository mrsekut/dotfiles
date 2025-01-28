{ config, pkgs, ... }:

{
  system = {
    stateVersion = 5;
    defaults = {
      dock = {
        autohide = true;
        show-recents = false;
        orientation = "left";
      };
    };
  };

  # imports = [
  #   # <home-manager/nix-darwin>
  #   # ./dock.nix
  #   # ./trackpad.nix
  #   # ./keyboard.nix
  #   # ./fonts.nix
  # ];

  # home-manager.useUserPackages = true;

  # homebrew = {
  #   enable = true;
  #   casks = [ "karabiner-elements" ];
  # };
}
