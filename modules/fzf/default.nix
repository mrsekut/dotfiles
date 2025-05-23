{ pkgs, ... }:

{
  home.packages = with pkgs; [ fzf ];

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    shellAliases = {
      cdd = "cd ~/Desktop";
      cdg = "cd $(ghq list --full-path | fzf)";
      codeg = "ghq list --full-path | fzf | xargs code";
      mkcd = ''f(){ mkdir -p "$1"; cd "$1" }; f'';
    };
  };
}
