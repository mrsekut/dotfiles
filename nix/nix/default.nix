{ pkgs, ... }:

{
  nix = {
    package = pkgs.nixVersions.stable;
    settings = {
      experimental-features = ''
        nix-command flakes
      '';
    };
  };

  home.packages = with pkgs; [
    nix-prefetch-git
  ];

  programs.zsh = {
    initExtra = ''
      export NIX_PATH=$HOME/.nix-defexpr/channels:$NIX_PATH

      # nix-darwin
      export PATH=/run/current-system/sw/bin:$PATH
      export NIX_PATH=darwin-config=$HOME/.nixpkgs/darwin-configuration.nix:$NIX_PATH
    '';
  };
}
