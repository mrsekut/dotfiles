{ ... }:

{
  system.defaults.trackpad = {
    Clicking = true;               # タップでクリックを有効化
    Dragging = false;              # タップでドラッグを無効化
    ActuationStrength = 1;         # サイレントクリックを無効（0で有効、1で無効）
    FirstClickThreshold = 0;       # 通常クリックのクリック圧：0=軽い, 1=普通, 2=重い
    SecondClickThreshold = 0;      # 強めのクリック（Force Click）のクリック圧：0=軽い, 1=普通, 2=重い
    TrackpadRightClick = true;     # トラックパッドで右クリックを有効
  };

  system.defaults.NSGlobalDomain."com.apple.trackpad.scaling" = 3.0; # 軌跡の速さ（マウス＆トラックパッドのカーソル移動速度）
}
