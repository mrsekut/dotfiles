{ pkgs, ... }:

{
  imports = [
    # languages
    # ./purescript
    # ./idris
    # ./ocaml
    ./javascript
    # ./java # for alloy
    # ./lean

    ./python
    ./rust
  ];
}