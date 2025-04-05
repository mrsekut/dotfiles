{ ... }:

{
  home.file.warp = {
    source = "${builtins.toString ./.}/warp_purple.yaml";
    target = ".warp/themes/warp_purple.yaml";
  };
}
