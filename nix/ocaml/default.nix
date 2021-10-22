{ pkgs, ... }:

{
  home.packages = with pkgs; [ opam ];

  programs.zsh = {
    initExtra = ''
      eval `opam config env`
    '';
  };
}
