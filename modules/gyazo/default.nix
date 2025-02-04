{ lib, ... }:
let
  target = name: ".config/karabiner/assets/complex_modifications/${name}.json";
in {
  home.file.karabinerGyazo = {
    target = target "gyazo";
    text = builtins.toJSON (lib.importJSON ./gyazo.json);
  };
  home.file.karabinerGyazoGif = {
    target = target "gyazo-gif";
    text = builtins.toJSON (lib.importJSON ./gyazo-gif.json);
  };
}