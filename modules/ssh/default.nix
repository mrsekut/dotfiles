{ config, agenix, ... }:

{
  home.packages = [ agenix ];

  # agenix 専用の鍵。PCごとに `just agenix-keygen` で作り、公開鍵を ./secrets.nix に登録する
  age.identityPaths = [ "${config.home.homeDirectory}/.ssh/agenix_ed25519" ];

  # ~/.ssh/config は丸ごと暗号化して管理する。編集は `just ssh-edit`
  age.secrets.ssh-config = {
    file = ./ssh-config.age;
    path = "${config.home.homeDirectory}/.ssh/config";
  };
}
