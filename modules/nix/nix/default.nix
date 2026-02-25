{ pkgs, config, lib, ... }:

{
  nix = {
    package = pkgs.nixVersions.stable;
    settings = lib.mkIf config.dotfiles.isPersonal {
      experimental-features = ''
        nix-command flakes
      '';
    };
  };

  home.packages = with pkgs; [
    nix-prefetch-git
  ];
}
