{ homebrew-cask, homebrew-bundle, ... }: {
  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = "mrsekut";
    # We use a fully declarative setup of Homebrew.
    mutableTaps = false;

    taps = {
      "homebrew/homebrew-cask" = homebrew-cask;
      "homebrew/homebrew-bundle" = homebrew-bundle;
    };
  };

  homebrew = {
    enable = true;
    # onActivation = {
    #   autoUpdate = true;
    #   # cleanup = "uninstall";
    # };

    # taps = [ ];
    # brews = [ ];
    masApps = {
      "toggl" = 1291898086;
      "kindle" = 302584613;
      # "xcode"
      # "zoom"
    };

    casks = [
      "orbstack"
      "fork"
      "monitorcontrol"
      "raycast"
      "karabiner-elements"
      "google-chrome"
    ];
  };
}
