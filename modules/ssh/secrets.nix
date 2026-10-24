# agenix の暗号化ルール。この dir の .age をどの公開鍵で復号可能にするかを定義する
# PCを追加したら公開鍵を足して `just ssh-rekey`
let
  personal = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIcW2Xa+cSkmHLYFHlpYPiTkMfKY7Ic0uaE/+pophBbw agenix@personal";
  # work = "ssh-ed25519 ... agenix@work";

  all = [ personal ];
in
{
  "ssh-config.age".publicKeys = all;
}
