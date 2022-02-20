{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nodePackages.typescript
    nodePackages.npm-check-updates
    nodejs-16_x
    yarn
  ];
}
