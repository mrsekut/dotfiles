{ ... }:

{
  # https://github.com/LnL7/nix-darwin/blob/master/modules/system/defaults/dock.nix
  system.defaults.dock = {
    appswitcher-all-displays = true;                  # appswitcher(cmd-tab)を全てのディスプレイに表示する
    enable-spring-load-actions-on-all-items = true;   # Dock上のdirにfileをDrag&Hoverすると自動で開く
    minimize-to-application = true;                   # 最小化したウィンドウをアプリのアイコンに収納する
    mru-spaces = false;                               # 最近使ったスペースを自動的に並び替えない
    orientation = "bottom";
    tilesize = 50;
    autohide = true;
  };
}
