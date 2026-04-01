{ lib, ... }:
let
  extensions = {
    # hover-translate
    "fcfadpdpofokcbfodeflpijhiiaieibn" = "https://raw.githubusercontent.com/mrsekut/hover-translate/master/update.xml";
  };

  forcelist = lib.mapAttrsToList (id: url: "${id};${url}") extensions;
  forcelistArgs = lib.concatMapStringsSep " " (e: "'${e}'") forcelist;
in
{
  system.activationScripts.postActivation.text = ''
    defaults write com.google.Chrome ExtensionInstallForcelist -array ${forcelistArgs}
  '';
}
