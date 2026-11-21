{
  homebrew-cask,
  homebrew-bundle,
  ...
}:
{
  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = "mrsekut";
    # We use a fully declarative setup of Homebrew.
    mutableTaps = false;

    taps = {
      "homebrew/homebrew-cask" = homebrew-cask;
      "homebrew/homebrew-bundle" = homebrew-bundle;
    };
  };

  homebrew = {
    enable = true;
    onActivation = {
      # Homebrew は既定で formulae.brew.sh の API キャッシュから cask を引くが、autoUpdate しないとこのキャッシュが古いままになり、
      # 新しい cask が "No Cask with this name exists" になる。nix で固定した tap を正とするため API を使わせない。
      extraEnv.HOMEBREW_NO_INSTALL_FROM_API = "1";
      # autoUpdate = true;
      # cleanup = "uninstall";
    };

    # taps = [ ];
    brews = [
    ];
    # GUIアプリは `dotfiles.apps` (modules/apps) 側で宣言する
  };
}
