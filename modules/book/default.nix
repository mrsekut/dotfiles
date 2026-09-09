{ pkgs, config, lib, ... }:

let
  # kindle2image (rye) / pdf2cosense (bun) / claude / md2cosense は
  # それぞれのリポジトリやユーザーの PATH 上にあり Nix で閉じられないので、
  # runtimeInputs には入れず book.sh 内の require_cmd で存在確認する。
  book = pkgs.writeShellApplication {
    name = "book";
    runtimeInputs = [ pkgs.ghq ];
    text = builtins.readFile ./book.sh;
  };
in
{
  home.packages = lib.optionals config.dotfiles.isPersonal [ book ];
}
