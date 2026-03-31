{ pkgs, lib, ... }:

{
  programs.zsh.shellAliases = {
    code = "cursor";
  };

  # Cursorの設定ファイルをdotfilesで管理する。
  # 実ファイルへの直接symlinkにすることで、Cursor側の変更がdotfilesに反映される。
  home.activation.cursor-settings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export PATH="${pkgs.git}/bin:$PATH"
    DOTFILES_DIR="$(${pkgs.ghq}/bin/ghq root)/github.com/mrsekut/dotfiles"
    CURSOR_DIR="$HOME/Library/Application Support/Cursor/User"
    mkdir -p "$CURSOR_DIR"
    ln -sf "$DOTFILES_DIR/modules/editors/cursor/settings/settings.json" "$CURSOR_DIR/settings.json"
    ln -sf "$DOTFILES_DIR/modules/editors/cursor/keybindings/keybindings.json" "$CURSOR_DIR/keybindings.json"
  '';
}
