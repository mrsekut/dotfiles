{ pkgs, ... }:

{
  home.packages = with pkgs; [
    rustc
    cargo
    clippy
    rustfmt
  ];

  programs.zsh = {
    initContent = ''
      export PATH=$HOME/.cargo/bin:$PATH
    '';
  };
}