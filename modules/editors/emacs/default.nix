{ ... }:

{
  programs.emacs = {
    enable = true;
  };

  home.file.".emacs".text = builtins.readFile ./init.el;
}
