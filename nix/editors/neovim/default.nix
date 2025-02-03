{ pkgs, ... }:

{
  programs.zsh.sessionVariables.EDITOR = "nvim";

  programs.neovim = {
    enable = true;
    vimAlias = true;
    extraConfig = builtins.readFile ./init.vim;
    # plugins = with pkgs.vimPlugins; [
    #     auto-pairs
    #     lightline-vim
    #     # ...
    #   ];
  };
}
