{
  description = "Agent skills catalog";

  inputs = {
    anthropic-skills = {
      url = "github:anthropics/skills";
      flake = false;
    };
    # Add more skill sources here:
    # my-skills = { url = "github:me/my-skills"; flake = false; };
  };

  outputs = { self, anthropic-skills, ... }: {
    homeManagerModules.default = {
      programs.agent-skills = {
        sources.anthropic = {
          path = anthropic-skills;
          subdir = "skills";
        };

        # Enable specific skills
        # See: https://github.com/anthropics/skills/tree/main/skills
        skills.enable = [
          "skill-creator"
          # "frontend-design"
          # "algorithmic-art"
        ];

        # Or enable all: skills.enableAll = true;
      };
    };
  };
}
