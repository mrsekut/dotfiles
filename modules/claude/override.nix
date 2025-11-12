{ claude-code, fetchzip }:
claude-code.overrideAttrs (oldAttrs: rec {
  version = "2.0.37";
  src = fetchzip {
    url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${version}.tgz";
    hash = "sha256-x4nHkwTE6qcB2PH+WPC0VyJTGeV6VTzeiiAsiQWChoo=";
  };
  npmDepsHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
})
