{ ... }:

{
  # OrbStackのCLIツール(docker, kubectl, orb, orbctl)へのPATHとzsh補完を読み込む。
  # 実体はOrbStackが生成する ~/.orbstack/shell/init.zsh。
  # (元はOrbStackが ~/.zprofile に勝手に追記していたものをdotfilesで宣言的に管理し直す)
  programs.zsh.profileExtra = ''
    source ~/.orbstack/shell/init.zsh 2>/dev/null || :
  '';
}
