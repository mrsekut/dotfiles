{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    jujutsu
    jjui
  ];

  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "mrsekut";
        email = "k.cloudspider@gmail.com";
      };
    };
  };

  programs.jjui.enable = true;
}
