{ lib, ... }:
let
  # target = name: ".config/karabiner/assets/complex_modifications/${name}.json";
in {
  # home.file.karabinerWarpHotkey = {
  #   target = target "warp-hotkey";
  #   text = builtins.toJSON (lib.importJSON ./warp-hotkey.json);
  # };
}