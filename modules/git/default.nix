{
  pkgs,
  lib,
  git-fixup,
  ...
}:

{
  home.packages = with pkgs; [
    git
    gh
    git-fixup
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
      rerere.enabled = true;
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
      fixup = "!git-fixup";

      # branch
      co = "checkout";
      sw = "switch";
      md = "merge develop";
      bd = "!zsh -c 'source ${builtins.toString ./.}/git-remove-branch.zsh'";

      # remote
      po = "push origin head";
      po-f = "push --force-with-lease";
      pull-f = "!f() { git fetch origin $(git rev-parse --abbrev-ref HEAD) && git reset --hard origin/$(git rev-parse --abbrev-ref HEAD); }; f";
      see = "!gh repo view --web";

      # その他のスクリプト操作
      ds = "!zsh -c 'source ${builtins.toString ./.}/git-delete-squashed.zsh' foo"; # delete squash TODO: `foo` is a hack
      rd = "!f() { git switch develop && git pull && git switch $1 && git rebase develop; }; f"; # ref: https://scrapbox.io/mrsekut-p/λ_git_rd
    };
  };

  programs.zsh.shellAliases = {
    ghrc = "${builtins.toString ./.}/gh_repo_create.zsh";
    wtcd = "cd $(git worktree list | fzf | awk '{print \$1}')";
  };

  # gitignore for global
  home.file.gitignore = {
    target = ".config/git/ignore";
    source = "${builtins.toString ./.}/gitignore";
  };

  # 実行前に gh auth で login が必要
  home.activation.installGhExtensions = lib.hm.dag.entryAfter [ "installPackages" ] ''
    PATH="${pkgs.git}/bin:$PATH"
    PATH="${pkgs.gh}/bin:$PATH"
    if ! gh extension list | grep -q 'kawarimidoll/gh-q'; then
      run gh extension install kawarimidoll/gh-q
    fi
  '';
}
