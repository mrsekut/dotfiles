{
  homebrew-cask,
  homebrew-bundle,
  satococoa-tap,
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
      "satococoa/homebrew-tap" = satococoa-tap;
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
      "wtp"
    ];
    masApps = {
      "toggl" = 1291898086;
      "kindle" = 302584613;
      # "xcode"
    };

    casks = [
      "1password"
      "chatgpt"
      "orbstack"
      "fork"
      "monitorcontrol"
      "raycast"
      "karabiner-elements"
      "google-chrome"
      "zoom"
    ];
  };
}
