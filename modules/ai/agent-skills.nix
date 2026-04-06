{ anthropic-skills, intellectronica-skills, mrsekut-skills, mrsekut-private-skills, openai-skills, playwriter-skills, cosense-cli-skills, ... }:
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
    sources.mrsekut = {
      path = mrsekut-skills;
    };
    sources.mrsekut-private = {
      path = mrsekut-private-skills;
    };
    sources.openai = {
      path = openai-skills;
      subdir = "skills/.curated";
      filter.nameRegex = "^screenshot$";
    };
    sources.playwriter = {
      path = playwriter-skills;
      subdir = "skills";
    };
    sources.cosense-cli = {
      path = cosense-cli-skills;
      subdir = "skills";
    };

    skills.enableAll = [ "mrsekut" "mrsekut-private" ];
    skills.enable = [
      "skill-creator"
      "context7"
      "nix-shell-deps"
      "playwriter"
      "screenshot"
      "cosense"
    ];
  };
}
