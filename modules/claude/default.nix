{ pkgs, ... }:

{
  home.packages = [
    pkgs.claude-code
  ];

  programs.zsh.shellAliases = {
    claude-yolo = "claude --dangerously-skip-permissions";
  };

  # modules/git/default.nix に書くか迷ったが、いったんclaude側の知見を集約するためにここに書く
  programs.git.settings.alias = {
    c-commit = "!git commit -m \"$(claude -p 'Look at the staged git changes and return only a summary title in English')\"";
  };
}
