{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cargo
  ];

  programs.zsh = {
    initExtra = ''
      export PATH=$HOME/.cargo/bin:$PATH
    '';
  };
}