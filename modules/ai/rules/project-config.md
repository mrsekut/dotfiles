# プロジェクト設定管理

## package.json設定原則

### ファイルパス指定
- エントリーポイントが `src/` ディレクトリにある場合は、すべてのスクリプトでパスを明示的に指定
- `main`, `module`, `bin` フィールドも適切なパスを指定
- 開発スクリプトとビルドスクリプトで一貫性を保つ

### Bunプロジェクトでの設定
- `type: "module"` を設定してES Modulesを使用
- dev スクリプトは `bun run src/index.ts` 形式で直接実行
- build スクリプトでも同じパスを使用して一貫性を保つ

### TUIアプリケーション設定
- ink を使用する場合は React と @types/react も必要
- peerDependencies で React のバージョンを明示
- デバッグ時は react-devtools-core を optionalDependencies に

## ディレクトリ構成とパス管理

### src/ ベース構成
```
src/
├── index.ts          # エントリーポイント
├── tui/             # TUI関連コンポーネント
├── commands/        # CLIコマンド（レガシー）
├── core/           # コアロジック
├── types/          # 型定義
└── utils/          # ユーティリティ
```

### package.json での設定例
```json
{
  "main": "dist/index.js",
  "module": "src/index.ts", 
  "bin": "dist/index.js",
  "scripts": {
    "dev": "bun run src/index.ts",
    "build": "bun build src/index.ts --outdir dist --target=node"
  }
}
```

## ビルド設定

### 相対パス管理
- 常に src/ からの相対パスを基準にする
- インポート時は .js 拡張子を明示（ES Modules要件）
- TypeScript設定と package.json の設定を一致させる

### エラー対処
- "Module not found" エラーが出た場合は package.json のパス設定を最初に確認
- dev/build スクリプトが同じファイルパスを参照していることを確認
- tsconfig.json の baseUrl 設定との整合性をチェック

## バックアップとマイグレーション

### CLI→TUI変換時
- 既存のCLI実装は `-backup.ts` ファイルとして保存
- エントリーポイントの変更時は package.json も同時更新
- 段階的な移行を心がけ、一度に大きく変更しない

### コミット戦略
- 設定変更は機能実装と分離してコミット
- package.json 修正は明確なコミットメッセージで記録
- ビルドエラー修正は即座にコミットして安定状態を保つ