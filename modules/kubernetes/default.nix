{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # kubectl
  ];

  programs.zsh = {
    shellAliases = {
      k = "kubectl";
    };
  };
}
