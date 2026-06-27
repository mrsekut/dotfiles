{ crit, pkgs, ... }:

{
  home.packages = [ crit.packages.${pkgs.system}.default ];

  programs.agent-skills = {
    sources.crit = {
      path = crit;
      subdir = "integrations/claude-code/skills";
    };
    skills.enable = [
      "crit"
      "crit-cli"
    ];
  };
}
