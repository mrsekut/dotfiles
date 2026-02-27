{
  homebrew-cask,
  homebrew-bundle,
  satococoa-tap,
  config,
  lib,
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
      # "xcode"
    } // lib.optionalAttrs config.dotfiles.isPersonal {
      "kindle" = 302584613;
    } // lib.optionalAttrs config.dotfiles.isWork {
      "okta-verify" = 490179405;
      "meetingbar" = 1532419400;
      "tootrain" = 1579538917;
    };

    casks = [
      "chatgpt"
      "orbstack"
      "fork"
      "monitorcontrol"
      "raycast"
      "karabiner-elements"
      "google-chrome"
      "zoom"
      "wispr-flow"
    ] ++ lib.optionals config.dotfiles.isWork [
      "obsidian"
    ];
  };
}
