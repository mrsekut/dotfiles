{ ... }:
{
  programs.zellij = {
    enable = true;
    enableZshIntegration = false; # 手動で起動するため自動起動は無効
  };

  xdg.configFile."zellij/config.kdl" = {
    source = ./config.kdl;
    force = true;
  };
}
