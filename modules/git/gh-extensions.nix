{ config, lib, pkgs, ... }:

{
  options.dotfiles.gh.extensions = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    example = [ "kawarimidoll/gh-q" ];
    description = "インストールする gh extension。各featureのモジュールから追加する";
  };

  # 実行前に gh auth で login が必要
  config.home.activation.installGhExtensions =
    lib.mkIf (config.dotfiles.gh.extensions != [ ]) (
      lib.hm.dag.entryAfter [ "installPackages" ] ''
        PATH="${pkgs.git}/bin:$PATH"
        PATH="${pkgs.gh}/bin:$PATH"
        for ext in ${lib.escapeShellArgs config.dotfiles.gh.extensions}; do
          if ! gh extension list | grep -q "$ext"; then
            run gh extension install "$ext"
          fi
        done
      ''
    );
}
