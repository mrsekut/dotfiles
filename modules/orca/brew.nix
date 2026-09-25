{ stablyai-orca-tap, ... }:
{
  nix-homebrew.taps."stablyai/homebrew-orca" = stablyai-orca-tap;

  dotfiles.apps.orca = {
    pname = "stablyai/orca/orca";
  };
}
