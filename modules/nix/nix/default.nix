{ pkgs, ... }:

{
  nix = {
    package = pkgs.nixVersions.stable;
    # settings = {
    #   experimental-features = ''
    #     nix-command flakes
    #   '';
    # };
  };

  home.packages = with pkgs; [
    nix-prefetch-git
  ];
}
