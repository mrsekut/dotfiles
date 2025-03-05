{ ... }:

{
  nix.enable = false;
  system.stateVersion = 5;

  imports = [
    # <home-manager/nix-darwin>
    ./darwin/dock.nix
    ./darwin/trackpad.nix
    ./keyboard/darwin.nix
    # ./fonts.nix
  ];
}
