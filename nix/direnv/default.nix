{ pkgs, ... }:

{
  home.packages = with pkgs; [
    direnv
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
    # nix-direnv.enableFlakes = true;
  };

  programs.zsh = {
    shellAliases = {
      nix-direnv = "echo 'use nix' >> .envrc && direnv allow";
    };
  };
}
