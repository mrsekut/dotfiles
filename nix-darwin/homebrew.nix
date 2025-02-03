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
    # masApps = [
    #   "toggl"
    #   "xcode"
    #   "zoom"
    # ];

    casks = [
      "orbstack"
      "gyazo"
      "fork"
      "monitorcontrol"
      "raycast"
      "visual-studio-code"
      "karabiner-elements"
      # "google-chrome"
    ];
  };
}
