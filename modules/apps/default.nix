{ config, lib, ... }:

let
  cfg = config.dotfiles.apps;

  # 現在のprofileで有効なアプリだけに絞る
  enabled = lib.filterAttrs (_: a: builtins.elem config.dotfiles.profile a.profiles) cfg;

  bySource = source: lib.filterAttrs (_: a: a.source == source) enabled;
in
{
  options.dotfiles.apps = lib.mkOption {
    description = "GUIアプリのインストール経路とログイン時起動をアプリ単位で宣言する";
    default = { };
    type = lib.types.attrsOf (lib.types.submodule ({ name, ... }: {
      options = {
        source = lib.mkOption {
          type = lib.types.enum [ "cask" "mas" ];
          default = "cask";
          description = "インストール経路";
        };

        pname = lib.mkOption {
          type = lib.types.str;
          default = name;
          description = "cask名 / masAppsのキー。attr名と違う場合だけ上書きする";
        };

        masId = lib.mkOption {
          type = lib.types.nullOr lib.types.int;
          default = null;
          description = "source = mas のときのApp Store ID";
        };

        launchAtLogin = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "ログイン時に起動する。値は `/Applications/<この名前>.app`";
        };

        profiles = lib.mkOption {
          type = lib.types.listOf (lib.types.enum [ "personal" "work" ]);
          default = [ "personal" "work" ];
          description = "このアプリを入れるprofile";
        };
      };
    }));
  };

  config = {
    # 細かい設定を持たないアプリはここに1行足すだけでよい。
    # 設定ファイル等を持つアプリは `modules/<feature>/` から `dotfiles.apps` に合流させる。
    dotfiles.apps = {
      chatgpt = { };
      fork = { };
      google-chrome = { };
      zoom = { };
      obsidian = {
        profiles = [ "work" ];
      };

      okta-verify = {
        source = "mas";
        masId = 490179405;
      };
      # toggl = { source = "mas"; masId = 1291898086; }; # errorになるのでコメントアウト
      # kindle = { source = "mas"; masId = 302584613; }; # errorになるのでコメントアウト

      raycast = {
        launchAtLogin = "Raycast";
      };
      monitorcontrol = {
        launchAtLogin = "MonitorControl";
      };
      wispr-flow = {
        launchAtLogin = "Wispr Flow";
      };
      cleanshotx = {
        pname = "cleanshot";
        launchAtLogin = "CleanShot X";
      };
      meetingbar = {
        source = "mas";
        masId = 1532419400;
        launchAtLogin = "MeetingBar";
        profiles = [ "work" ];
      };
    };

    assertions = lib.mapAttrsToList
      (name: a: {
        assertion = (a.source == "mas") == (a.masId != null);
        message = "dotfiles.apps.${name}: masId は source = \"mas\" のときだけ指定する";
      })
      cfg;

    homebrew.casks = lib.mapAttrsToList (_: a: a.pname) (bySource "cask");

    homebrew.masApps = lib.mapAttrs' (_: a: lib.nameValuePair a.pname a.masId) (bySource "mas");

    # macOSのログイン項目はper-userのSharedFileList plist(バイナリ)で宣言的に触れないので、
    # `open -a` を叩くlaunchd agentで代替する。
    # nix-darwinの`launchd.user.agents`は`~/Library/LaunchAgents`に置かれる。
    launchd.user.agents = lib.mapAttrs
      (_: a: {
        serviceConfig = {
          ProgramArguments = [ "/usr/bin/open" "-a" a.launchAtLogin ];
          RunAtLoad = true;
        };
      })
      (lib.filterAttrs (_: a: a.launchAtLogin != null) enabled);
  };
}
