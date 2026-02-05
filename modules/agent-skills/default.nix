{ ... }:

{
  programs.agent-skills = {
    enable = true;

    targets = {
      agents = {
        dest = "$HOME/.agents/skills";
        structure = "symlink-tree";
      };
      claude = {
        dest = "\${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills";
        structure = "symlink-tree";
      };
    };
  };
}
