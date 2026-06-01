{ pkgs, cosense-skills, ... }:

let
  cosense-cli = pkgs.writeShellApplication {
    name = "cosense";
    runtimeInputs = [ pkgs.bun ];
    text = ''
      exec bun run ${cosense-skills}/src/cli.ts "$@"
    '';
  };
in
{
  home.packages = [ cosense-cli ];
}
