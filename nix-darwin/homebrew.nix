{inputs, ...}: {
  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = "mrsekut";
    # We use a fully declarative setup of Homebrew.
    mutableTaps = false;

    taps = {
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
      "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
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
    #   "xcode"
    # ]

    casks = [
      "orbstack"
      "fork"
      "warp"

      # 存在するか知らないが、いったん書いておく
      # "google-chrome",
      # "vscode",
      # "karabiner-elements",
      # "MonitorControl",
      # "Toggl",
      # "Google IME",
      # "Raycast",
      # "Gyazo"
      # "zoom"
    ];
  };
}