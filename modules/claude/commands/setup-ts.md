# Setup TypeScript

TypeScript プロジェクトの初期セットアップを支援してください。
以下の条件に従い、品質を担保するために必要なセットアップを設計し、ユーザに確認・合意しながら進めてください。

# 要件

- TypeScript プロジェクトにおいて、形式的に担保可能な品質管理のセットアップを行いたい。
- 下記のものは提案に含め、ユーザの希望があればそちらを優先する

## typecheck

- 型チェックを実行するコマンドを用意
  - `bun run typecheck`
- 最も厳しい tsconfig の定義

```tsconfig.json
{
  "compilerOptions": {
    "strict": true,
    "allowUnusedLabels": false,
    "allowUnreachableCode": false,
    "exactOptionalPropertyTypes": true,
    "noFallthroughCasesInSwitch": true,
    "noImplicitOverride": true,
    "noImplicitReturns": true,
    "noPropertyAccessFromIndexSignature": true,
    "noUncheckedIndexedAccess": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,

    "isolatedModules": true,

    "checkJs": true,

    "esModuleInterop": true,
    "skipLibCheck": true
  },
}
```

## test

- vitest などのテストフレームワークを導入する
- テストを実行するコマンドを用意

```package.json
"scripts": {
  "test": "vitest"
}
```

## lint

- 厳しめの ESLint 設定を定義
- チェックと修正を同時にできるコマンドを用意

```package.json
"scripts": {
  "lint": "eslint . --fix"
}
```

## format

- prettier のルールを定義
- チェックと修正を同時にできるコマンドを用意

```package.json
"scripts": {
  "format": "prettier --write ."
}
```

## MCP

- 必要であれば MCP を導入する
- .mcp.json を用意する

## Claude Code Hooks

```.claude/settings.json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit|MultiEdit",
        "hooks": [
          {
            "type": "command",
            "command": "bun run typecheck"
          }
        ]
      }
    ]
  }
}
```

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
    "test": "vitest",
    "check": "bun run typecheck && bun run lint && bun run format && bun run test"
  }
  ```

- 実行できることを確認する

4. もしユーザーが一部の設定をカスタマイズしたい場合は、その意図を確認し、最適な代替案を提案すること。
