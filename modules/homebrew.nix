{ homebrew-cask, homebrew-bundle, ... }:
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
      "okta-verify" = 490179405;
      "meetingbar" = 1532419400;
      "tootrain" = 1579538917;
      # "toggl" = 1291898086;
      # "kindle" = 302584613;
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
      "cursor"
      "arc"
    ];
  };
}
