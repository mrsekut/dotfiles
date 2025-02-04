{ lib, ... }:
let
  target = name: ".config/karabiner/assets/complex_modifications/${name}.json";
in {
  home.file.karabinerCmd = {
    target = target "cmd";
    text = builtins.toJSON (lib.importJSON ./cmd.json);
  };
  home.file.karabinerCtrlHJKL = {
    target = target "ctrl_hjkl";
    text = builtins.toJSON (lib.importJSON ./ctrl_hjkl.json);
  };
}