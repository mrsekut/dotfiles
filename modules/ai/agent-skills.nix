{ anthropic-skills, intellectronica-skills, sdd-skills, mrsekut-skills, openai-skills, ... }:
{
  programs.agent-skills = {
    sources.anthropic = {
      path = anthropic-skills;
      subdir = "skills";
      filter.nameRegex = "^(skill-creator|context7)$";
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
    sources.openai = {
      path = openai-skills;
      subdir = "skills/.curated";
      filter.nameRegex = "^screenshot$";
    };

    skills.enableAll = [ "mrsekut" ];
    skills.enable = [
      "skill-creator"
      "context7"
      "nix-shell-deps"
      "sdd"
      "screenshot"
    ];
  };
}
