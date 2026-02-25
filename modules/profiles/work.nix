{ pkgs, ... }:

{
  home.packages = with pkgs; [
    google-cloud-sdk
    uv
    argo-workflows
  ];

  programs.git.includes = [
    {
      condition = "gitdir:~/Desktop/dev/github.com/herp-inc-hq/";
      contents = {
        user = {
          name = "kota-marusue_herpinc";
          email = "kota.marusue@herp.co.jp";
        };
      };
    }
  ];
}
