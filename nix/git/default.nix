{ pkgs, ... }:

{
  home.packages = with pkgs; [
    git
    hub

    git-absorb
  ];

  programs.git = {
    enable = true;
    userName = "mrsekut";
    userEmail = "k.cloudspider@gmail.com";

    extraConfig = {
      rebase.autosquash = true;
      color.ui = true;
      help.autocorrect = 1;
      ghq.root = "~/Desktop/dev";
    };

    delta.enable = true;

    aliases = {
      graph = "log --graph --date-order --pretty=format:\"%C(magenta)<%h> %C(yellow)%ad %C(green)(%cr) %C(cyan)[%an] %C(white)%d%C(reset) %s\" --all --date=short";
      ssb = "status --short --branch";
      aa = "add --all";
      ac = "!git add --all && git commit";
      co = "checkout";
      see = "!hub browse -- pull/$(git symbolic-ref --short HEAD)";
      po = "push origin head";
      pro = "!git push -u origin $(git symbolic-ref --short HEAD) && git see";
      md = "merge develop";
      fp = "fetch -p";
      bd = "!zsh -c 'source ${builtins.toString ./.}/git-remove-branch.zsh'";
      fixup = "!zsh -c 'source ${builtins.toString ./.}/git-fixup.zsh'";
    };
  };
}
