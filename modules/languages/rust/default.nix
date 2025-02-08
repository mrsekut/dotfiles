{ pkgs, ... }:

{
  home.packages = with pkgs; [
    rustup
  ];

  programs.zsh = {
    initExtra = ''
      export PATH=$HOME/.cargo/bin:$PATH
    '';
  };
}