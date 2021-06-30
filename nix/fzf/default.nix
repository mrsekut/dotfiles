{ pkgs, ... }:

{
  home.packages = with pkgs; [ fzf ];

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    shellAliases = {
      cdd = "cd $(ghq list --full-path | fzf) && code .";
      cdg = "cd $(ghq list --full-path | fzf)";
      codeg = "ghq list --full-path | fzf | xargs code";
    };
  };
}
