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

    # https://scrapbox.io/mrsekut-p/DIRENV_WARN_TIMEOUT
    initExtra = ''
      export DIRENV_WARN_TIMEOUT=5s
    '';
  };
}
