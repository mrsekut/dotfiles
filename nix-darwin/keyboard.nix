{ ... }:

{
  system.defaults.NSGlobalDomain = {
    # allow key repeat
    ApplePressAndHoldEnabled = false;
    # delay before repeating keystrokes
    InitialKeyRepeat = 10;
    # delay between repeated keystrokes upon holding a key
    KeyRepeat = 2;
    AppleShowAllExtensions = true;
    AppleShowScrollBars = "Automatic";
  };

  # system.keyboard = {
  #   enableKeyMapping = true;
  #   remapCapsLockToControl = true;
  #   swapLeftCommandAndLeftAlt = true;
  # };
}
