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
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    satococoa-tap = {
      url = "github:satococoa/homebrew-tap";
      flake = false;
    };

    codex.url = "github:herp-inc-hq/codex";

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
      codex,
      nix-darwin,
      nix-homebrew,
      homebrew-cask,
      homebrew-bundle,
      satococoa-tap,
      git-fixup,
      gyou,
      ...
    }:
    let
      system = "aarch64-darwin";
      # system = "x86_64-darwin";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfreePredicate =
          pkg:
          builtins.elem (nixpkgs.lib.getName pkg) [
            "claude-code"
            "terraform"
          ];
      };
      claude-code-override = pkgs.callPackage ./modules/claude/override.nix { };
    in
    {
      packages.${system} = { inherit claude-code-override; };
      homeConfigurations = {
        config.codex.enable = true;
        mrsekut = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          extraSpecialArgs = {
            git-fixup = git-fixup.packages.${system}.default;
            gyou = gyou.packages.${system}.default;
            inherit claude-code-override;
          };

          modules = [
            ./modules/home-manager.nix
            codex.hmModule.${system}
            { codex.enable = true; }
          ];
        };
      };

      darwinConfigurations = {
        mrsekut = nix-darwin.lib.darwinSystem {
          specialArgs = { inherit homebrew-cask homebrew-bundle satococoa-tap; };
          system = system;
          modules = [
            ./modules/nix-darwin.nix
            nix-homebrew.darwinModules.nix-homebrew
            ./modules/homebrew.nix
            ./modules/terminals/warp/brew.nix
            ./modules/gyazo/brew.nix
            ./modules/claude/brew.nix
            ./modules/editors/cursor/brew.nix
            ./modules/wtp/brew.nix
          ];
        };
      };
    };
}
