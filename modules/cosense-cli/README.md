# helpfeel/cosense-cliの透過的な認証解決をするラッパー

公式の cosense-cli の手前に立つ薄いラッパー
渡された Cosense の URL から project 名を取り出し、project ごとに使う認証情報(PAT)を自動で選んで `COSENSE_PAT` を注入したうえで公式 CLI を起動する。

## なぜ必要か

公式 CLI の認証は origin (`scrapbox.io`) 単位で 1 つしか使えず、複数アカウントを使い分けられない。個人アカウントで大半のプロジェクトに入りつつ、特定プロジェクトだけ会社アカウント、という運用ができない。
このラッパーが「project → どのアカウント」のルーティングを担う。

## 仕組み

- `default.nix` が `cosense` という名前の `writeShellApplication` を作り PATH に置く。
  PATH 上の `cosense` はこれ 1 つだけなので、`cosense ...` は必ずラッパーを経由する(透過)。
- ラッパーは `router.ts` を `bun run` する。`router.ts` が `~/.config/cosense-cli/config.json`
  の対応表を見て profile を解決し、`COSENSE_PAT` を注入して公式 CLI(`COSENSE_OFFICIAL_CLI`)を起動する。
- config や token が無くても落とさず、認証なしで公式に素通しする
  (`--version` / `--help` / public プロジェクトはそのまま動く)。

## 各 PC でのセットアップ

config.json は token(秘密) を含むため **dotfiles には含めず、各 PC で手動作成**する。

### 1. config を用意

```sh
mkdir -p ~/.config/cosense-cli
cp <dotfiles>/modules/cosense-cli/config.example.json ~/.config/cosense-cli/config.json
chmod 600 ~/.config/cosense-cli/config.json
```

### 2. PAT を発行して埋める

アカウントごとに Personal Access Token を発行する。発行フローは以下で確認できる:

```sh
cosense login https://scrapbox.io
```

- **個人アカウント**でログインした状態で発行 → `profiles.personal.token` に貼る
- **会社(SAML)アカウント**に切り替えて発行 → `profiles.work.token` に貼る

### 3. ルーティングを設定

`config.json` の構造:

| key         | 意味                                                              |
| ----------- | ----------------------------------------------------------------- |
| `profiles`  | 認証情報。`<profile名>: { "token": "<PAT>" }`                     |
| `default`   | どの project にも当てはまらない時に使う profile。基本は個人       |
| `overrides` | `<project名>: <profile名>`。デフォルト以外を使う project だけ列挙 |

100 個の個人プロジェクトは登録不要(すべて `default` に流れる)。
別アカウントの project が増えたら `overrides` に 1 行足すだけ。

### 4. 動作確認

```sh
# それぞれ読めれば project ごとに正しいアカウントが当たっている (403 なら設定ミス)
cosense browsePage 'https://scrapbox.io/hoge-inc/<page>'      # 会社アカウント
cosense browsePage 'https://scrapbox.io/<個人project>/<page>' # 個人アカウント
```
