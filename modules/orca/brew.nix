{ ... }:
{
  homebrew = {
    casks = [
      # tap は modules/homebrew.nix の nix-homebrew.taps で宣言的に固定している
      "stablyai/orca/orca"
    ];
  };
}
