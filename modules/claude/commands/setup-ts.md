# Setup TypeScript

TypeScript プロジェクトの初期セットアップを支援してください。
以下の条件に従い、品質を担保するために必要なセットアップを設計し、ユーザに確認・合意しながら進めてください。

# 要件

- TypeScript プロジェクトにおいて、形式的に担保可能な品質管理のセットアップを行いたい。
- 下記のものは提案に含め、ユーザの希望があればそちらを優先する

## typecheck

- 最も厳しい tsconfig の定義
- 型チェックを実行するコマンドを用意

## test

- vitest などのテストフレームワークを導入する
- テストを実行するコマンドを用意

## lint

- 厳しめの ESLint 設定を定義
- コマンドを用意

## format

- prettier のルールを定義
- コマンドを用意

## MCP

- 必要であれば MCP を導入する
- .mcp.json を用意する
- 使えることを確認する

## ci

- CI 設定を提案する
- 基本的に github actions を使う

# 進め方

1. 上記の要件を加味して、構成案をユーザに提案し、合意を取ること。

2. 合意が取れたら、セットアップ用のコマンド一覧を提示する。
   bun を使っている場合の例:

   - `bun run typecheck`
   - `bun run lint`
   - `bun run format`
   - `bun run test`

3. 上記のコマンドを実行できるように実装を進める

- 必要なパッケージをインストール
- 設定ファイルを作成
  - tsconfig.json
  - .eslintrc.js
  - vitest.config.ts
  - .prettierrc
  - ci.yml
- etc.

- package.json の scripts にコマンドを追加
  下記は例である。使用しているツールによってコマンドが異なる。

  ```package.json
  "scripts": {
    "typecheck": "tsc --noEmit",
    "lint": "eslint . --ext .ts,.tsx --fix",
    "format": "prettier --write .",
    "test": "vitest run",
    "check": "bun run typecheck && bun run lint && bun run format && bun run test"
  }
  ```

- 実行できることを確認する

4. もしユーザーが一部の設定をカスタマイズしたい場合は、その意図を確認し、最適な代替案を提案すること。
