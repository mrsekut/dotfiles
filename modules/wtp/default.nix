{ ... }:

{
  programs.zsh = {
    initContent = builtins.readFile ./wtp.zsh;
  };
}
