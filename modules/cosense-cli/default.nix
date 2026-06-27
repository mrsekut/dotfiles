{ pkgs, cosense-skills, ... }:

let
  cosense-cli = pkgs.writeShellApplication {
    name = "cosense";
    runtimeInputs = [ pkgs.bun ];
    # 透過ラッパー: PATH上の `cosense` はこの router を必ず経由する。
    # router が project→PAT を解決し COSENSE_PAT を注入したうえで、
    # COSENSE_OFFICIAL_CLI が指す公式 CLI を起動する。
    text = ''
      export COSENSE_OFFICIAL_CLI="${cosense-skills}/src/cli.ts"
      exec bun run ${./router.ts} "$@"
    '';
  };
in
{
  home.packages = [ cosense-cli ];

  programs.agent-skills = {
    sources.cosense = {
      path = cosense-skills;
      subdir = "skills";
    };
    skills.enable = [
      "cosense"
    ];
  };
}
