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
      "gyazo"
      "fork"
      "warp"
      "monitorcontrol"
      "raycast"

      # 存在するか知らないが、いったん書いておく
      # "google-chrome",
      # "vscode",
      # "karabiner-elements",
      # "zoom"
    ];
  };
}