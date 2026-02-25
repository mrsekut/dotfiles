{ config, lib, ... }:

{
  nix = {
    enable = lib.mkIf config.dotfiles.isWork false;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
  };
  system.stateVersion = 5;
  system.primaryUser = "mrsekut";

  imports = [
    # <home-manager/nix-darwin>
    ./darwin/dock.nix
    ./darwin/trackpad.nix
    ./keyboard/darwin.nix
    # ./fonts.nix
  ];
}
