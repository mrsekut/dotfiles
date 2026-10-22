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
    stablyai-orca-tap = {
      url = "github:stablyai/homebrew-orca";
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

    crit = {
      url = "github:tomasz-tomczyk/crit";
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
    cosense-skills = {
      url = "github:helpfeel/cosense-cli";
      flake = false;
    };
    gh-stack-skills = {
      url = "github:github/gh-stack";
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
      stablyai-orca-tap,
      git-fixup,
      nix-index-database,
      nix-claude-code,
      crit,
      agent-skills,
      anthropic-skills,
      intellectronica-skills,
      mrsekut-skills,
      mrsekut-private-skills,
      openai-skills,
      playwriter-skills,
      cosense-skills,
      gh-stack-skills,
      ...
    }:
    let
      system = "aarch64-darwin";
      # system = "x86_64-darwin";

      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          nix-claude-code.overlays.default
          # TODO(2026-10-22): 一時対応。nixos-unstable の brotli が 1.2.1 以上になったら
          # `nix flake update nixpkgs` してこの overlay を消す。
          # Nix の nodejs は --shared-brotli で Nix 側の libbrotli を使うため、node を上げても
          # CVE-2026-111497 (brotli decoder の OOB write → RCE) は直らない。
          # brotli 全体を差し替えると大量の再ビルドになるので、node にだけ修正版を渡す。
          # brotli は v24.nix / v26.nix 内の callPackage ./nodejs.nix で注入されるため、
          # nodejs-slim_* の callPackage を差し替えて渡す (nodejs_* は nodejs-slim_* の symlink)。
          (
            _final: prev:
            let
              brotli-cve-2026-111497 = prev.brotli.overrideAttrs (_: rec {
                version = "1.2.1";
                src = prev.fetchFromGitHub {
                  owner = "google";
                  repo = "brotli";
                  tag = "v${version}";
                  hash = "sha256-llY72cYffDv0ugsH0p89xIPEbElV4L8u7U/Fe8hT3gI=";
                };
              });
              withFixedBrotli =
                pkg:
                pkg.override {
                  callPackage = fn: args: prev.callPackage fn (args // { brotli = brotli-cve-2026-111497; });
                };
            in
            {
              nodejs-slim_24 = withFixedBrotli prev.nodejs-slim_24;
              nodejs-slim_26 = withFixedBrotli prev.nodejs-slim_26;
            }
          )
        ];
        config.allowUnfreePredicate =
          pkg:
          builtins.elem (nixpkgs.lib.getName pkg) [
            "1password-cli"
            "claude-code"
            "terraform"
          ];
      };

      commonHomeModules = [
        nix-index-database.homeModules.nix-index
        agent-skills.homeManagerModules.default
        ./modules/ai/agent-skills.nix
        ./modules/home-manager.nix
      ];

      commonExtraSpecialArgs = {
        git-fixup = git-fixup.packages.${system}.default;
        # crit はバイナリと skill の両方を flake source から取り出すため、
        # package ではなく flake input そのものを渡し、module 側で導出する。
        inherit crit;
        inherit anthropic-skills intellectronica-skills mrsekut-skills mrsekut-private-skills openai-skills playwriter-skills cosense-skills gh-stack-skills;
      };

      commonDarwinModules = [
        ./modules/options.nix
        ./modules/nix-darwin.nix
        nix-homebrew.darwinModules.nix-homebrew
        ./modules/homebrew.nix
        ./modules/apps
        ./modules/keyboard/karabiner/app.nix
        ./modules/1password/app.nix
        ./modules/terminals/warp/app.nix
        ./modules/ai/claude/app.nix
        ./modules/editors/cursor/app.nix
        ./modules/orbstack/app.nix
        ./modules/orca/app.nix
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
          specialArgs = { inherit homebrew-cask homebrew-bundle stablyai-orca-tap; };
          system = system;
          modules = commonDarwinModules ++ [
            { dotfiles.profile = "personal"; }
          ];
        };

        "mrsekut@work" = nix-darwin.lib.darwinSystem {
          specialArgs = { inherit homebrew-cask homebrew-bundle stablyai-orca-tap; };
          system = system;
          modules = commonDarwinModules ++ [
            { dotfiles.profile = "work"; }
          ];
        };
      };
    };
}
