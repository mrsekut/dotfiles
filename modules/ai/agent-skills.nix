{ codex, anthropic-skills, intellectronica-skills, mrsekut-skills, mrsekut-private-skills, openai-skills, playwriter-skills, cosense-skills, cognitive-rhythm-writing-skill, japanese-tech-writing-skill, ... }:
{
  programs.agent-skills = {
    sources.codex = {
      path = codex;
      subdir = "skills";
    };
    sources.anthropic = {
      path = anthropic-skills;
      subdir = "skills";
      filter.nameRegex = "^(skill-creator|context7)$";
    };
    sources.intellectronica = {
      path = intellectronica-skills;
      subdir = "skills";
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
    # k16shikano さんの Gist。cognitive-rhythm-writing は ../japanese-tech-writing を参照する
    sources.cognitive-rhythm-writing = {
      path = cognitive-rhythm-writing-skill;
    };
    sources.japanese-tech-writing = {
      path = japanese-tech-writing-skill;
    };

    skills.enableAll = [ "mrsekut" "mrsekut-private" ];
    skills.enable = [
      "skill-creator"
      "context7"
      "playwriter"
      "screenshot"
      "cognitive-rhythm-writing"
      "japanese-tech-writing"
      "get-aws-credentials"
      "share-internal-resource"
    ];
  };
}
