{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nodePackages.typescript
    nodePackages.npm-check-updates
    nodePackages.pnpm
    nodejs-16_x
    yarn
  ];
}
