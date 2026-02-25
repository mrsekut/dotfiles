{ ... }:

{
  # Determinate Nix との競合回避
  nix.enable = false;

  homebrew = {
    masApps = {
      "okta-verify" = 490179405;
      "meetingbar" = 1532419400;
      "tootrain" = 1579538917;
    };
    casks = [
      "cursor"
      "obsidian"
    ];
  };
}
