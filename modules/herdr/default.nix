{ config, lib, ... }:

let
  # Herdr は Settings 画面の操作やリセットで settings.json / keys.json に書き込むので、
  # 読み取り専用の Nix store ではなく、dotfiles 内の実ファイルへ直接リンクする。
  here = "${config.home.homeDirectory}/dev/github.com/mrsekut/dotfiles/modules/herdr";
  link = name: config.lib.file.mkOutOfStoreSymlink "${here}/${name}";
in
{
  # ~/.config/herdr-app/ のうち、自分で書くファイルだけを管理する。
  # 同梱の layouts/mods や状態ファイル (view.json, shared.json, installed.json など) は Herdr が書き換えるので管理しない。
  # 自作のレイアウトや mod を作ったら、ここに追加する。
  home.file.".config/herdr-app/settings.json".source = link "settings.json";
  home.file.".config/herdr-app/keys.json".source = link "keys.json";

  # Option+Space で Herdr をトグルする Karabiner のルール。Karabiner の画面で Enable する。
  home.file.".config/karabiner/assets/complex_modifications/herdr_toggle.json".text =
    builtins.toJSON (lib.importJSON ./karabiner_toggle.json);

  # インストーラが hc / herdr-core / herdr-app を ~/.local/bin に置く
  home.sessionPath = [ "$HOME/.local/bin" ];
}
