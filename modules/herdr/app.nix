{ ... }:
{
  # cask の zap は ~/.config/herdr-app を丸ごと消すので、homebrew の cleanup を "zap" にするときは注意する。
  dotfiles.apps.herdr-app = { };
}
