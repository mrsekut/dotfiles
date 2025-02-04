{ ... }:

{
  programs.home-manager.enable = true;

  home = {
    username = "mrsekut";
    homeDirectory = "/Users/mrsekut";
    stateVersion = "24.11";
  };

  imports = [
    ./nix
    ./editors
    ./languages
    ./terminals

    # commands
    ./bat
    ./eza
    ./ripgrep
    ./ast-grep
    ./fzf

    # others
    ./git
    ./utils
    ./gyazo
    ./karabiner
  ];
}