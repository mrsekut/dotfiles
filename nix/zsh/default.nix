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

    shellAliases = {
      c = "clear";
    };

    initExtra = ''
      source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


      # nix-profileにpathを通す
      if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer


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

    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.2.0";
          sha256 = "1gfyrgn23zpwv1vj37gf28hf5z0ka0w5qm6286a7qixwv7ijnrx9";
        };
      }
    ];
  };
}
