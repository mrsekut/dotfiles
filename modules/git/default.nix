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
    bun
  ];

  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "mrsekut";
        email = "k.cloudspider@gmail.com";
      };
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

      alias = {
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
        bd = "!${pkgs.bun}/bin/bun run ${./scripts/git-remove-branch.ts}";

        # cherry-pick
        cp = "cherry-pick";
        cp-i = "!${pkgs.bun}/bin/bun run ${./scripts/cherry-pick-interactive.ts}";

        # remote
        po = "push origin head";
        po-f = "push --force-with-lease";
        pull-f = "!f() { git fetch origin $(git rev-parse --abbrev-ref HEAD) && git reset --hard origin/$(git rev-parse --abbrev-ref HEAD); }; f";
        see = "!gh repo view --web";
        tagpush = "!f() { git tag \"$1\" && git push origin \"$1\"; }; f";

        # その他のスクリプト操作
        stack-branch = "!${pkgs.bun}/bin/bun run ${./scripts/stack-branch.ts}";
        rd = "!f() { git switch develop && git pull && git switch $1 && git rebase develop; }; f"; # ref: https://scrapbox.io/mrsekut-p/λ_git_rd
      };
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.zsh.shellAliases = {
    ghrc = "${pkgs.bun}/bin/bun run ${./scripts/gh-repo-create.ts}";
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
