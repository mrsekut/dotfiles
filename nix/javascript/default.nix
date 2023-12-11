{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nodePackages.typescript
    nodePackages.npm-check-updates
    nodejs_20
    yarn
  ];
}
