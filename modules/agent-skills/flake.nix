{
  description = "Agent skills catalog";

  inputs = {
    anthropic-skills = {
      url = "github:anthropics/skills";
      flake = false;
    };
    intellectronica-skills = {
      url = "github:intellectronica/agent-skills";
      flake = false;
    };
    sdd-skills = {
      url = "github:mrsekut/sdd-skills";
      flake = false;
    };
  };

  outputs = { self, anthropic-skills, intellectronica-skills, sdd-skills, ... }: {
    homeManagerModules.default = {
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
          path = ./skills;
        };
        sources.sdd = {
          path = sdd-skills;
        };

        skills.enable = [
          "skill-creator"
          "context7"
          "nix-shell-deps"
          "sdd"
        ];
      };
    };
  };
}
