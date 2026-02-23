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
    mrsekut-skills = {
      url = "github:mrsekut/agent-skills";
      flake = false;
    };
  };

  outputs = { self, anthropic-skills, intellectronica-skills, sdd-skills, mrsekut-skills, ... }: {
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
    };
  };
}
