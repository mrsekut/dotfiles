{ claude-code-override, ... }:

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
}
