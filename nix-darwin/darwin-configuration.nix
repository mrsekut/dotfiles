{ config, pkgs, ... }:

{
  imports = [ <home-manager/nix-darwin> ];
  home-manager.useUserPackages = true;


  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [ pkgs.vim ];

  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  system.defaults = {
  #   finder = {
  #     AppleShowAllExtensions = true;
  #     FXEnableExtensionChangeWarning = true;
  #     _FXShowPosixPathInTitle = true;
  #   };

    dock = {
      autohide = true;
      autohide-delay = "0.0";
      autohide-time-modifier = "1.0";
      tilesize = 50;
      static-only = false;
      showhidden = false;
      show-recents = false;
      show-process-indicators = true;
      orientation = "bottom";
      mru-spaces = false;
    };

  #   NSGlobalDomain = {
  #     AppleInterfaceStyle = "Dark";
  #     "com.apple.sound.beep.feedback" = 0;
  #     "com.apple.sound.beep.volume" = "0.000";
  #     # allow key repeat
  #     ApplePressAndHoldEnabled = false;
  #     # delay before repeating keystrokes
  #     InitialKeyRepeat = 10;
  #     # delay between repeated keystrokes upon holding a key
  #     KeyRepeat = 2;
  #     AppleShowAllExtensions = true;
  #     AppleShowScrollBars = "Automatic";
  #   };
  };

  # system.keyboard = {
  #   enableKeyMapping = true;
  #   remapCapsLockToControl = true;
  #   swapLeftCommandAndLeftAlt = true;
  # };

  # fonts = {
  #   enableFontDir = true;
  #   fonts = with pkgs;
  #     [ (nerdfonts.override { fonts = [ "FiraCode" "VictorMono" ]; }) ];
  # };

  # homebrew = {
  #   enable = true;
  #   casks = [ "karabiner-elements" ];
  # };
}
