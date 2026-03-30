{ pkgs, ... }:

{
  programs.claude-code = {
    enable = true;
    package = pkgs.claude-code;
  };

  programs.zsh.shellAliases = {
    c = "claude --dangerously-skip-permissions";
  };

  # ~/.claude/settings.json は動的に変更されるためdotfiles管理外。
  # statusLineの設定は手動で以下を追記する:
  #   "statusLine": { "type": "command", "command": "bash ~/.claude/statusline-command.sh", "padding": 0 }
  home.file.".claude/statusline-command.sh" = {
    source = ./statusline-command.sh;
    executable = true;
  };

  # modules/git/default.nix に書くか迷ったが、いったんclaude側の知見を集約するためにここに書く
  programs.git.settings.alias = {
    c-commit = "!git commit -m \"$(claude -p 'Look at the staged git changes and return only a summary title in English')\"";
  };
}
