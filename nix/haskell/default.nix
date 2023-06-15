{ pkgs, ... }:

{
  programs.zsh = {
    initExtra = ''
      # curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
      export PATH=$HOME/.ghcup/bin:$PATH
    '';
  };
}
