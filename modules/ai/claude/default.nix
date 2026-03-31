{ pkgs, lib, ... }:

{
  programs.claude-code = {
    enable = true;
    package = pkgs.claude-code;
  };

  # ~/.claude/settings.json をdotfilesで管理する。
  # home.fileはNix store経由(read-only)になるため、
  # Claude Codeが書き換えられるよう実ファイルへの直接symlinkにする。
  home.activation.claude-settings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export PATH="${pkgs.git}/bin:$PATH"
    DOTFILES_DIR="$(${pkgs.ghq}/bin/ghq root)/github.com/mrsekut/dotfiles"
    ln -sf "$DOTFILES_DIR/modules/ai/claude/settings.json" "$HOME/.claude/settings.json"
  '';

  programs.zsh.shellAliases = {
    c = "claude --dangerously-skip-permissions";
  };

  home.file.".claude/statusline-command.sh" = {
    source = ./statusline-command.sh;
    executable = true;
  };

  # modules/git/default.nix に書くか迷ったが、いったんclaude側の知見を集約するためにここに書く
  programs.git.settings.alias = {
    c-commit = "!git commit -m \"$(claude -p 'Look at the staged git changes and return only a summary title in English')\"";
  };
}
