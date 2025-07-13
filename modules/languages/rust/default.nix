{ pkgs, ... }:

{
  home.packages = with pkgs; [
    rustup
  ];

  programs.zsh = {
    initContent = ''
      export PATH=$HOME/.cargo/bin:$PATH
    '';
  };
}