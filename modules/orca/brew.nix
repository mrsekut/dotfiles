{ ... }:
{
  dotfiles.apps.orca = {
    # tap は modules/homebrew.nix の nix-homebrew.taps で宣言的に固定している
    pname = "stablyai/orca/orca";
  };
}
