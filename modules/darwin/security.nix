{ ... }:

{
  # sudoでTouch IDを有効化（tmux内でも動作させるためreattach=true）
  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
  };
}
