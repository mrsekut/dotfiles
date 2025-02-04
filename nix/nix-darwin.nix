{ ... }:

{
  system.stateVersion = 5;

  imports = [
    # <home-manager/nix-darwin>
    ./darwin/dock.nix
    ./darwin/trackpad.nix
    ./darwin/keyboard.nix
    # ./fonts.nix
  ];
}
