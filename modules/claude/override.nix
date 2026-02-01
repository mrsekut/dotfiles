{ claude-code, fetchzip }:
claude-code.overrideAttrs (oldAttrs: rec {
  version = "2.1.29";
  src = fetchzip {
    url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${version}.tgz";
    hash = "sha256-bRXULCl5F87SWEcsD9S8ZaBrEK2QtK/GEhpEFR1CMWQ=";
  };
  npmDepsHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
})
