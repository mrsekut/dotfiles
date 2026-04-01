{ pkgs, hover-translate-src, ... }:
let
  hover-translate = pkgs.stdenv.mkDerivation {
    pname = "hover-translate";
    version = "0.0.1";
    src = hover-translate-src;

    offlineCache = pkgs.fetchYarnDeps {
      yarnLock = hover-translate-src + "/yarn.lock";
      hash = "sha256-O/PiX0HDmqHfS7LC9GmpAbdE2Ej/qq49b9S87gZ8sc4=";
    };

    nativeBuildInputs = with pkgs; [
      nodejs
      yarnConfigHook
      yarnBuildHook
    ];

    buildPhase = ''
      runHook preBuild
      yarn build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      cp -r build/chrome-mv3-prod $out
      runHook postInstall
    '';
  };
in
{
  home.file.".local/share/chrome-extensions/hover-translate".source = hover-translate;
}
