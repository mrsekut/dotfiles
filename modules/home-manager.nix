{ ... }:

{
  programs.home-manager.enable = true;

  home = {
    username = "mrsekut";
    homeDirectory = "/Users/mrsekut";
    stateVersion = "24.11";
  };

  imports = [
    ./options.nix
    ./nix
    ./editors
    ./languages
    ./terminals
    ./ai
    ./1password
    ./terraform

    # commands
    ./bat
    ./eza
    ./ripgrep
    ./ast-grep
    ./fzf

    # others
    ./git
    ./utils
    ./keyboard/karabiner
    ./gomi
    ./kubernetes
    ./wtp
    ./yazi
    ./launchd
  ];
}
