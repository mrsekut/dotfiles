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
      core = {
        ignorecase = false;
      };
      rebase = {
        autosquash = true;
        autostash = true;
      };
      merge.conflictstyle = "diff3";
      # pull.rebase = true;
      fetch.prune = true;
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
      ca = "commit --amend";
      co = "checkout";
      sw = "switch";
      see = "!hub browse -- pull/$(git symbolic-ref --short HEAD)";
      po = "push origin head";
      pro = "!git push -u origin $(git symbolic-ref --short HEAD) && git see";
      md = "merge develop";
      pull-f = "!git fetch && git reset --hard origin";
      bd = "!zsh -c 'source ${builtins.toString ./.}/git-remove-branch.zsh'";
      fixup = "!zsh -c 'source ${builtins.toString ./.}/git-fixup.zsh'";
      ds = "!zsh -c 'source ${builtins.toString ./.}/git-delete-squashed.zsh' foo"; # delete squash TODO: `foo` is a hack
    };
  };
}
