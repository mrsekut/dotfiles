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
      # log
      graph = "log --graph --date-order --pretty=format:\"%C(magenta)<%h> %C(yellow)%ad %C(green)(%cr) %C(cyan)[%an] %C(white)%d%C(reset) %s\" --all --date=short";

      # status
      ssb = "status --short --branch";

      # add, commit
      aa = "add --all";
      ac = "!git add --all && git commit";
      ca = "commit --amend";
      fixup = "!zsh -c 'source ${builtins.toString ./.}/git-fixup.zsh'";

      # branch
      co = "checkout";
      sw = "switch";
      md = "merge develop";
      bd = "!zsh -c 'source ${builtins.toString ./.}/git-remove-branch.zsh'";

      # remote
      po = "push origin head";
      po-f = "push --force-with-lease";
      pro = "!git push -u origin $(git symbolic-ref --short HEAD) && git see";
      pull-f = "!f() { git fetch origin $(git rev-parse --abbrev-ref HEAD) && git reset --hard origin/$(git rev-parse --abbrev-ref HEAD); }; f";
      see = "!hub browse -- pull/$(git symbolic-ref --short HEAD)";

      # その他のスクリプト操作
      ds = "!zsh -c 'source ${builtins.toString ./.}/git-delete-squashed.zsh' foo"; # delete squash TODO: `foo` is a hack
      rd = "!f() { git switch develop && git pull && git switch $1 && git rebase develop; }; f"; # ref: https://scrapbox.io/mrsekut-p/λ_git_rd
    };

  };
}
