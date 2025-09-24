{ claude-code, fetchzip }:
claude-code.overrideAttrs (oldAttrs: rec {
  version = "1.0.123";
  src = fetchzip {
    url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${version}.tgz";
    hash = "sha256-bzI6wYnY3kBA8xKOeQqYpsi672FIrcSj3eAN0nFqz5o=";
  };
  npmDepsHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
})
