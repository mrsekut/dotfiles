{ pkgs, config, lib, ... }:

{
  nix = {
    package = pkgs.nixVersions.stable;
    settings = lib.mkIf config.dotfiles.isPersonal {
      experimental-features = ''
        nix-command flakes
      '';
    };
  };

  # nix.gc.options は1つの引数として渡されて nix-collect-garbage に弾かれるため、引数を直接指定する
  nix.gc = {
    automatic = true;
    dates = "weekly";
  };
  launchd.agents.nix-gc.config.ProgramArguments = lib.mkForce [
    "${config.nix.package}/bin/nix-collect-garbage"
    "--delete-older-than"
    "14d"
  ];

  home.packages = with pkgs; [
    nix-prefetch-git
  ];
}
