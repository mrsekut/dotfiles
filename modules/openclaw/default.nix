{ config, lib, pkgs, ... }:

let
  getSecret = envVar:
    let val = builtins.getEnv envVar;
    in if val == ""
      then builtins.trace "WARNING: ${envVar} not set. Use 'just home-manager-apply-personal'." ""
      else val;
in
{
  # Secrets are injected via environment variables from 1Password (see justfile)
  programs.openclaw = lib.mkIf config.dotfiles.isPersonal {
    enable = true;

    # Workaround: explicitly define instance to avoid missing nixMode bug in defaultInstance
    instances.default = {
      # Lower priority to avoid conflict with nodejs_latest
      package = lib.lowPrio pkgs.openclaw;
      config = {
        gateway = {
          mode = "local";
          auth.token = getSecret "OPENCLAW_GATEWAY_TOKEN";
        };

        channels.discord.accounts.default = {
          token = getSecret "OPENCLAW_DISCORD_TOKEN";
          allowFrom = [ "376933549263159306" ];
        };
      };
    };
  };

  launchd.agents.openclaw-secrets = lib.mkIf config.dotfiles.isPersonal {
    enable = true;
    config = {
      ProgramArguments = [
        "/bin/bash" "-c"
        ''
          sleep 5
          KEY_FILE="/Users/mrsekut/.secrets/openclaw/anthropic-api-key"
          if [ -f "$KEY_FILE" ]; then
            API_KEY="$(cat "$KEY_FILE")"
            if [ -n "$API_KEY" ]; then
              /bin/launchctl setenv ANTHROPIC_API_KEY "$API_KEY"
              /bin/launchctl kickstart -k "gui/$(/usr/bin/id -u)/com.steipete.openclaw.gateway" 2>/dev/null || true
            fi
          fi
        ''
      ];
      RunAtLoad = true;
      KeepAlive = false;
      StandardOutPath = "/tmp/openclaw-secrets.log";
      StandardErrorPath = "/tmp/openclaw-secrets.log";
    };
  };
}
