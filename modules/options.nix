{ lib, config, ... }:

{
  options.dotfiles = {
    profile = lib.mkOption {
      type = lib.types.enum [ "personal" "work" ];
      description = "Which machine profile to use";
    };

    isPersonal = lib.mkOption {
      type = lib.types.bool;
      default = config.dotfiles.profile == "personal";
      readOnly = true;
    };

    isWork = lib.mkOption {
      type = lib.types.bool;
      default = config.dotfiles.profile == "work";
      readOnly = true;
    };
  };
}
