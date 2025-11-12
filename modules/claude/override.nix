{ claude-code, fetchzip }:
claude-code.overrideAttrs (oldAttrs: rec {
  version = "2.0.55";
  src = fetchzip {
    url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${version}.tgz";
    hash = "sha256-wsjOkNxuBLMYprjaZQyUZHiqWl8UG7cZ1njkyKZpRYg=";
  };
  npmDepsHash = "sha256-cPy2xudIH1OVVzDlq5YAg1uFu59h6zDOvXpKaJ+fuP8=";
})
