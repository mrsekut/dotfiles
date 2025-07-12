{ lib, claude-code-override, ... }:

{
  home.packages = [
    claude-code-override
  ];

  programs.zsh.shellAliases = {
    claude-yolo = "claude --dangerously-skip-permissions";
  };

  # modules/git/default.nix に書くか迷ったが、いったんclaude側の知見を集約するためにここに書く
  programs.git.aliases = {
    c-commit = "!git commit -m \"$(claude -p 'Look at the staged git changes and return only a summary title in English')\"";
  };

  # Claude commandsを実ファイルとしてコピー
  home.activation.claudeCommands = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p $HOME/.claude/commands
    for file in ${./commands}/*.md; do
      if [ -f "$file" ]; then
        filename=$(basename "$file")
        cp -f "$file" "$HOME/.claude/commands/$filename"
        chmod 644 "$HOME/.claude/commands/$filename"
      fi
    done
  '';
}
