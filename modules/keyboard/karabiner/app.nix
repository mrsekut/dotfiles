{ ... }:
{
  # launchAtLoginはしない。
  # `org.pqrs.service.agent.Karabiner-Core-Service-rev2`等がSMAppServiceで常駐登録されていて
  # そちらがキーリマップの本体。`open -a`は設定ウィンドウを開くだけ。
  dotfiles.apps.karabiner-elements = { };
}
