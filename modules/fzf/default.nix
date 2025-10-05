{ pkgs, ... }:

{
  home.packages = with pkgs; [ fzf ];

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    shellAliases = {
      cdg = "cd $(ghq list --full-path | fzf)";
    };
  };
}
