{ anthropic-skills, intellectronica-skills, sdd-skills, mrsekut-skills, ... }:
{
  programs.agent-skills = {
    sources.anthropic = {
      path = anthropic-skills;
      subdir = "skills";
    };
    sources.intellectronica = {
      path = intellectronica-skills;
      subdir = "skills";
    };
    sources.local = {
      path = ./agent-skills/skills;
    };
    sources.sdd = {
      path = sdd-skills;
    };
    sources.mrsekut = {
      path = mrsekut-skills;
    };

    skills.enable = [
      "skill-creator"
      "context7"
      "nix-shell-deps"
      "sdd"
      "chrome-store-submit"
    ];
  };
}
