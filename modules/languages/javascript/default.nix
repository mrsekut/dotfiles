{ pkgs, ... }:

{
  home.packages = with pkgs; [
    typescript
    npm-check-updates
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
