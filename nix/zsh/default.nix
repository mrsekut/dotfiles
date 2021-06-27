{ config, pkgs, ... }:

{
  # home.packages = with pkgs; [
  #   zsh-autosuggestions
  #   zsh-completions
  #   zsh-history-substring-search
  #   zsh-syntax-highlighting
  # ];

  programs.zsh = {
    enable = true;

    autocd = true;
    enableCompletion = true;
    enableAutosuggestions = true;

    # shellGlobalAliases = {
    #   "..." = "../..";
    #   "...." = "../../..";
    #   "....." = "../../../..";
    #   DN = "/dev/null";
    #   EG = "|& egrep";
    #   EL = "|& less";
    #   ET = "|& tail";
    # };

    # oh-my-zsh = {
    #   enable = true;
    #   plugins = [ "globalias" ];
    # };

    # plugins = [
    #   {
    #     name = "fzf-tab";
    #     src = pkgs.fetchFromGitHub {
    #       owner = "Aloxaf";
    #       repo = "fzf-tab";
    #       rev = "51e6755bb32add73469a06274f5b3a0d665ce1df";
    #       sha256 = "05k2pjr4zd34id6d1jhfd7rq011717i6axf0j5ya0wz13sw5qj6w";
    #     };
    #   }
    #   {
    #     name = "enhancd";
    #     file = "init.sh";
    #     src = pkgs.fetchFromGitHub {
    #       owner = "b4b4r07";
    #       repo = "enhancd";
    #       rev = "aec0e0c1c0b1376e87da74b8940fda5657269948";
    #       sha256 = "13n2c2kj25g8aqvlkb5j4vzcz5a4a22yc8v6ary651lpqgckx7cg";
    #     };
    #   }
    # ];

  #   initExtraBeforeCompInit = ''
  #     source ${config.home.homeDirectory}/.nix-profile/etc/profile.d/nix.sh

  #     fpath=( ${config.xdg.configHome}/zsh/functions "''${fpath[@]}" )
  #     autoload -Uz $fpath[1]/*
  #   '';

  #   initExtra = ''
  #     zstyle ':completion:*:descriptions' format '[%d]'

  #     # popup menu - requires tmux 3.2+
  #     zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

  #     # complete manual by their section
  #     zstyle ':completion:*:manuals'   separate-sections true
  #     zstyle ':completion:*:manuals.*' insert-sections   true
  #     zstyle ':completion:*:man:*'     menu yes select

  #     source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

  #     function take() {
  #       mkdir -p $1
  #       cd $1
  #     }

  #     bindkey \^U backward-kill-line
  #   '';
  };
}
