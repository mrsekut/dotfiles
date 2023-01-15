{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nodePackages.typescript
    nodePackages.npm-check-updates
    nodejs-18_x
    yarn
  ];
}
