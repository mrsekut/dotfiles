{ pkgs, ... }:

{
  home.packages = with pkgs; [ opam ];

  programs.zsh = {
    initContent = ''
      eval `opam config env`
    '';
  };
}
