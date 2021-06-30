{ pkgs, ... }:

{
  home.packages = with pkgs; [
    zsh-autosuggestions
    zsh-completions
    zsh-history-substring-search
    zsh-syntax-highlighting
  ];

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;

    # oh-my-zsh = {
    #   enable = true;
    # };

    initExtra = ''
      source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


      # zsh-history-substring-search
      source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down


      # vim for zsh
      bindkey -v

      # emacs for zsh
      bindkey -e


      # my modular dotfiles
      source "$HOME/Desktop/dev/github.com/mrsekut/dotfiles/zsh/export.zsh"


      # ctrl-rでhistoryをfzfを使って表示
      function select-history() {
        BUFFER=$(history -n -r 1 | fzf --no-sort +m --query "$LBUFFER" --prompt="History > ")
        CURSOR=$#BUFFER
      }
      zle -N select-history
      bindkey '^r' select-history
    '';
  };
}
