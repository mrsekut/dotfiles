{ pkgs, lib, ... }:

let
  # claude-codeのカスタムバージョン（nixpkgsの更新を待たずに最新版を使用）
  claude-code-custom = pkgs.claude-code.overrideAttrs (oldAttrs: rec {
    version = "1.0.27";
    src = pkgs.fetchzip {
      url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${version}.tgz";
      hash = "sha256-HnlJo93RfsZdUZiXfnojDjp3BVSBNJ3YX/6silX9VUU=";
    };
    npmDepsHash = "sha256-7jbvsIXulG6dJOnMc5MjDOnMc5MjDm/Kcyndm4jDSdj85eSp/hc=";
  });
in
{
  home.packages = [
    claude-code-custom
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
