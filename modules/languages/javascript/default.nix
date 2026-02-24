{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nodePackages.typescript
    nodePackages.npm-check-updates
    nodejs_latest
    yarn
    bun
    ni
  ];

  programs.zsh = {
    initContent = ''
      # bun linkしたパッケージを直接実行できるようにする
      export PATH=$HOME/.bun/bin:$PATH
    '';
  };
}
