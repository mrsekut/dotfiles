
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    claude-code
  ];

  programs.zsh.shellAliases = {
    claude-yolo = "claude --dangerously-skip-permissions";
  };
}
