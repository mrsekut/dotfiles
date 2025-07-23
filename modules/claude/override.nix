{ claude-code, fetchzip }:
claude-code.overrideAttrs (oldAttrs: rec {
  version = "1.0.58";
  src = fetchzip {
    url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${version}.tgz";
    hash = "sha256-Mp3S269iifNGSEz83IF6bqbgdy6Im1bQjR8oaaL3W8c=";
  };
  npmDepsHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
})
