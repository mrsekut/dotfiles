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
    # nix-index-database (for comma)
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-claude-code = {
      url = "github:ryoppippi/nix-claude-code";
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
    mrsekut-skills = {
      url = "github:mrsekut/agent-skills";
      flake = false;
    };
    mrsekut-private-skills = {
      url = "git+ssh://git@github.com/mrsekut/agent-skills-private";
      flake = false;
    };
    openai-skills = {
      url = "github:openai/skills";
      flake = false;
    };
    playwriter-skills = {
      url = "github:remorses/playwriter";
      flake = false;
    };

    # Chrome Extensions
    hover-translate-src = {
      url = "git+ssh://git@github.com/mrsekut/hover-translate";
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
      nix-index-database,
      nix-claude-code,
      agent-skills,
      anthropic-skills,
      intellectronica-skills,
      mrsekut-skills,
      mrsekut-private-skills,
      openai-skills,
      playwriter-skills,
      hover-translate-src,
      ...
    }:
    let
      system = "aarch64-darwin";
      # system = "x86_64-darwin";

      pkgs = import nixpkgs {
        inherit system;
        overlays = [ nix-claude-code.overlays.default ];
        config.allowUnfreePredicate =
          pkg:
          builtins.elem (nixpkgs.lib.getName pkg) [
            "1password-cli"
            "claude-code"
            "terraform"
          ];
      };

      commonHomeModules = [
        nix-index-database.hmModules.nix-index
        agent-skills.homeManagerModules.default
        ./modules/ai/agent-skills.nix
        ./modules/home-manager.nix
      ];

      commonExtraSpecialArgs = {
        git-fixup = git-fixup.packages.${system}.default;
        inherit anthropic-skills intellectronica-skills mrsekut-skills mrsekut-private-skills openai-skills playwriter-skills;
        inherit hover-translate-src;
      };

      commonDarwinModules = [
        ./modules/options.nix
        ./modules/nix-darwin.nix
        nix-homebrew.darwinModules.nix-homebrew
        ./modules/homebrew.nix
        ./modules/1password/brew.nix
        ./modules/terminals/warp/brew.nix
        ./modules/gyazo/brew.nix
        ./modules/ai/claude/brew.nix
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
