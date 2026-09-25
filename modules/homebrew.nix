{
  homebrew-cask,
  homebrew-bundle,
  stablyai-orca-tap,
  ...
}:
{
  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = "mrsekut";
    # We use a fully declarative setup of Homebrew.
    mutableTaps = false;

    taps = {
      "homebrew/homebrew-cask" = homebrew-cask;
      "homebrew/homebrew-bundle" = homebrew-bundle;
      "stablyai/homebrew-orca" = stablyai-orca-tap;
    };
  };

  homebrew = {
    enable = true;
    # onActivation = {
    #   autoUpdate = true;
    #   # cleanup = "uninstall";
    # };

    # taps = [ ];
    brews = [
    ];
    # GUIアプリは `dotfiles.apps` (modules/apps) 側で宣言する
  };
}
