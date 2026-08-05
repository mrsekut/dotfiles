{ gh-stack-skills, ... }:

# CLI本体は gh extension、skill は flake input から取得するため、
# 両者のバージョンは揃わない
{
  dotfiles.gh.extensions = [ "github/gh-stack" ];

  programs.agent-skills = {
    sources.gh-stack = {
      path = gh-stack-skills;
      subdir = "skills";
    };
    skills.enable = [ "gh-stack" ];
  };
}
