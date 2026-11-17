{ pkgs, lib, config, ... }:

{
  home.packages =
    with pkgs;
    [
      typescript
      npm-check-updates
      pnpm
      bun
    ]
    # work では codex の標準パッケージが社内で固定した nodejs を入れるので、
    # node コマンドが衝突しないよう personal だけで入れる。
    ++ lib.optionals config.dotfiles.isPersonal [ nodejs_latest ];

  programs.zsh = {
    initContent = ''
      # bun linkしたパッケージを直接実行できるようにする
      export PATH=$HOME/.bun/bin:$PATH
    '';
  };
}
