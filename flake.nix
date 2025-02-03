{
  description = "my dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    nix-darwin,
    nix-homebrew,
    homebrew-cask,
    homebrew-bundle,
    ...
  } @inputs : let
    system = "aarch64-darwin";
    # system = "x86_64-darwin";

    pkgs = nixpkgs.legacyPackages.${system};
  in {
    homeConfigurations = {
      mrsekut = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./nix/home.nix ];
      };
    };

    darwinConfigurations = {
      mrsekut = nix-darwin.lib.darwinSystem {
        specialArgs = {inherit homebrew-cask homebrew-bundle;};
        system = system;
        modules = [
          ./nix-darwin/configuration.nix
          nix-homebrew.darwinModules.nix-homebrew
          ./nix-darwin/homebrew.nix
        ];
      };
    };
  };
}
