{
  description = "my dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };

    # mrsekut's libraries
    git-fixup = {
      url = "github:mrsekut/git-fixup";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    gyou = {
      url = "github:mrsekut/gyou";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nix-darwin,
      nix-homebrew,
      homebrew-cask,
      homebrew-bundle,
      git-fixup,
      gyou,
      ...
    }:
    let
      system = "aarch64-darwin";
      # system = "x86_64-darwin";

      pkgs = nixpkgs.legacyPackages.${system};
      claude-code-override = pkgs.callPackage ./modules/claude/override.nix { };
    in
    {
      packages.${system} = {
        inherit claude-code-override;
      };
      homeConfigurations = {
        mrsekut = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            git-fixup = git-fixup.packages.${system}.default;
            gyou = gyou.packages.${system}.default;
            inherit claude-code-override;
          };
          modules = [ ./modules/home-manager.nix ];
        };
      };

      darwinConfigurations = {
        mrsekut = nix-darwin.lib.darwinSystem {
          specialArgs = { inherit homebrew-cask homebrew-bundle; };
          system = system;
          modules = [
            ./modules/nix-darwin.nix
            nix-homebrew.darwinModules.nix-homebrew
            ./modules/homebrew.nix
            ./modules/terminals/warp/brew.nix
            ./modules/gyazo/brew.nix
            ./modules/claude/brew.nix
            ./modules/editors/vscode/brew.nix
          ];
        };
      };
    };
}
