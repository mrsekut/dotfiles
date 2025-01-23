{
  description = "my dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ...}: {
    defaultPackage = {
      x86_64-darwin = home-manager.defaultPackage.x86_64-darwin;
      aarch64-darwin = home-manager.defaultPackage.aarch64-darwin;
    };

    homeConfigurations = {
      "mrsekut" = home-manager.lib.homeManagerConfiguration {
        modules = [ ./nix/home.nix ]; # TODO: 見てない
      };
    };
  };
}
