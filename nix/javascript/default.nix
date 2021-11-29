{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nodePackages.typescript
    nodejs
    # yarn
    deno
  ];
}
