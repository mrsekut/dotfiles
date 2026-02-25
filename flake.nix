{
  description = "my dotfiles";

  inputs = {
    # NOTE: codex が nix_2_29 を参照しているため、古い nixpkgs に固定 (2025-12-14)
    # codex が nix_2_31 に対応したら nixos-unstable に戻す
    nixpkgs.url = "github:nixos/nixpkgs/d02bcc33948ca19b0aaa0213fe987ceec1f4ebe1";

    # NOTE: nixpkgs を固定したため、対応する home-manager も固定 (2025-12-14)
    home-manager = {
      url = "github:nix-community/home-manager/58bf3ecb2d0bba7bdf363fc8a6c4d49b4d509d03";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NOTE: nixpkgs 25.05 に合わせて nix-darwin-25.05 ブランチを使用
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.05";
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

    codex = {
      url = "github:herp-inc-hq/codex";
      inputs.nixpkgs.follows = "nixpkgs";
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
      codex,
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
        overlays = [ codex.overlays.default ];
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
        ./modules/options.nix
        ./modules/nix-darwin.nix
        nix-homebrew.darwinModules.nix-homebrew
        ./modules/homebrew.nix
        ./modules/terminals/warp/brew.nix
        ./modules/gyazo/brew.nix
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
          ];
        };

        "mrsekut@work" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = commonExtraSpecialArgs;
          modules = commonHomeModules ++ [
            { dotfiles.profile = "work"; }
            codex.homeModules.default
            { codex.enable = true; }
          ];
        };
      };

      darwinConfigurations = {
        "mrsekut@personal" = nix-darwin.lib.darwinSystem {
          specialArgs = { inherit homebrew-cask homebrew-bundle satococoa-tap; };
          system = system;
          modules = commonDarwinModules ++ [
            { dotfiles.profile = "personal"; }
          ];
        };

        "mrsekut@work" = nix-darwin.lib.darwinSystem {
          specialArgs = { inherit homebrew-cask homebrew-bundle satococoa-tap; };
          system = system;
          modules = commonDarwinModules ++ [
            { dotfiles.profile = "work"; }
          ];
        };
      };
    };
}
