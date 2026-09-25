{
  homebrew-cask,
  homebrew-bundle,
  stablyai-orca-tap,
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
    masApps = {
      "okta-verify" = 490179405;
      # "toggl" = 1291898086; # errorになるのでコメントアウト
      # "xcode"
    } // lib.optionalAttrs config.dotfiles.isPersonal {
      # "kindle" = 302584613; # errorになるのでコメントアウト
    };

    casks = [
      "chatgpt"
      "fork"
      "karabiner-elements"
      "google-chrome"
      "zoom"
    ] ++ lib.optionals config.dotfiles.isWork [
      "obsidian"
    ];
  };
}
