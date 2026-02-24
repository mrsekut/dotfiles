{ pkgs, ... }:

{
  home.packages = with pkgs; [
    go
    gopls
  ];

  programs.zsh = {
    initContent = ''
      export GOPATH=$HOME/go
      export PATH=$GOPATH/bin:$PATH
    '';
  };
}
