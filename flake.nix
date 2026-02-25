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

    # mrsekut's libraries
    git-fixup = {
      url = "github:mrsekut/git-fixup";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    gyou = {
      url = "github:mrsekut/gyou";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-index-database (for comma)
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Agent Skills
    agent-skills = {
      url = "github:Kyure-A/agent-skills-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    anthropic-skills = {
      url = "github:anthropics/skills";
      flake = false;
    };
    intellectronica-skills = {
      url = "github:intellectronica/agent-skills";
      flake = false;
    };
    sdd-skills = {
      url = "github:mrsekut/sdd-skills";
      flake = false;
    };
    mrsekut-skills = {
      url = "github:mrsekut/agent-skills";
      flake = false;
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
      satococoa-tap,
      git-fixup,
      gyou,
      nix-index-database,
      agent-skills,
      anthropic-skills,
      intellectronica-skills,
      sdd-skills,
      mrsekut-skills,
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

      commonHomeModules = [
        nix-index-database.hmModules.nix-index
        agent-skills.homeManagerModules.default
        ./modules/agent-skills.nix
        ./modules/home-manager.nix
      ];

      commonExtraSpecialArgs = {
        git-fixup = git-fixup.packages.${system}.default;
        gyou = gyou.packages.${system}.default;
        inherit anthropic-skills intellectronica-skills sdd-skills mrsekut-skills;
      };

      commonDarwinModules = [
        ./modules/nix-darwin.nix
        nix-homebrew.darwinModules.nix-homebrew
        ./modules/homebrew.nix
        ./modules/terminals/warp/brew.nix
        ./modules/claude/brew.nix
        ./modules/editors/cursor/brew.nix
        ./modules/wtp/brew.nix
      ];
    in
    {
      homeConfigurations = {
        "mrsekut@personal" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = commonExtraSpecialArgs;
          modules = commonHomeModules ++ [
            { dotfiles.profile = "personal"; }
            ./modules/profiles/personal.nix
          ];
        };

        "mrsekut@work" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = commonExtraSpecialArgs;
          modules = commonHomeModules ++ [
            { dotfiles.profile = "work"; }
            ./modules/profiles/work.nix
          ];
        };
      };

      darwinConfigurations = {
        "mrsekut@personal" = nix-darwin.lib.darwinSystem {
          specialArgs = { inherit homebrew-cask homebrew-bundle satococoa-tap; };
          system = system;
          modules = commonDarwinModules ++ [
            ./modules/gyazo/brew.nix
            ./modules/profiles/personal-darwin.nix
          ];
        };

        "mrsekut@work" = nix-darwin.lib.darwinSystem {
          specialArgs = { inherit homebrew-cask homebrew-bundle satococoa-tap; };
          system = system;
          modules = commonDarwinModules ++ [
            ./modules/profiles/work-darwin.nix
          ];
        };
      };
    };
}
