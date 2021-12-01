{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nix-prefetch-git
  ];

  programs.zsh = {
    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.2.0";
          sha256 = "1gfyrgn23zpwv1vj37gf28hf5z0ka0w5qm6286a7qixwv7ijnrx9";
        };
      }
    ];
  };
}
