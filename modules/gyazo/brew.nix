{ config, lib, ... }:

lib.mkIf config.dotfiles.isPersonal {
  homebrew = {
    casks = [
      # "gyazo"
    ];
  };
}
