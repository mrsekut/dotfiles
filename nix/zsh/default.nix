{ config, pkgs, ... }:

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

    plugins = [
      {
        name = "enhancd";
        file = "init.sh";
        src = pkgs.fetchFromGitHub {
          owner = "b4b4r07";
          repo = "enhancd";
          rev = "aec0e0c1c0b1376e87da74b8940fda5657269948";
          sha256 = "13n2c2kj25g8aqvlkb5j4vzcz5a4a22yc8v6ary651lpqgckx7cg";
        };
      }
    ];

    initExtra = ''
      source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

      # zsh-history-substring-search
      source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down

      # vim for zsh
      bindkey -v

      # my modular dotfiles
      source "$HOME/Desktop/dev/github.com/mrsekut/dotfiles/zsh/export.zsh"
    '';
  };
}
