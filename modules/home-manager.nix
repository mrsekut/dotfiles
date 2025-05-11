{ lib, ... }:

{
  programs.home-manager.enable = true;

  home = {
    username = "mrsekut";
    homeDirectory = "/Users/mrsekut";
    stateVersion = "24.11";
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "claude-code"
      "terraform"
    ];

  imports = [
    ./nix
    ./editors
    ./languages
    ./terminals
    ./claude
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
  ];
}