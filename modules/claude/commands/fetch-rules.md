# Fetch Rules

AI ルールリポジトリ (https://github.com/mrsekut/dotfiles/modules/ai/rules) から当プロジェクトに適切なルールを取得し、CLAUDE.md を更新してください。

## 実行手順

### Step 1: プロジェクト分析

以下を並行して分析し、プロジェクトタイプを特定してください：

- **プロジェクト構成ファイル**: package.json, Cargo.toml, pyproject.toml, go.mod, requirements.txt など
- **設定ファイル**: tsconfig.json, .eslintrc, .prettierrc, webpack.config.js など
- **エントリーポイント**: main ファイル（index.js/ts, main.py, main.go など）
- **ディレクトリ構造**: src/, components/, tests/ などの構造から推測
- **既存の CLAUDE.md**: 現在のルール状況の確認

### Step 2: ルール取得

GitHub API を使用して利用可能なルールを確認し、プロジェクトタイプに応じて関連ルールを取得：

```bash
# 利用可能なルール一覧を取得
curl -s https://api.github.com/repos/mrsekut/dotfiles/modules/ai/rules/contents/rules | jq -r '.[].name'

# プロジェクトタイプに基づいて関連するルールを並行取得
# 例: TypeScript React プロジェクトの場合
curl -s https://raw.githubusercontent.com/mrsekut/dotfiles/main/modules/ai/rules/rules/typescript.md
curl -s https://raw.githubusercontent.com/mrsekut/dotfiles/main/modules/ai/rules/rules/react.md
curl -s https://raw.githubusercontent.com/mrsekut/dotfiles/main/modules/ai/rules/rules/coding.md
curl -s https://raw.githubusercontent.com/mrsekut/dotfiles/main/modules/ai/rules/rules/git.md
```

### Step 3: CLAUDE.md 更新

- 既存の CLAUDE.md をバックアップ（存在する場合）
- プロジェクト概要を含む構造化された CLAUDE.md を作成
- 取得したルールをプロジェクトの特性に合わせて統合

## CLAUDE.md 構造テンプレート

```markdown
# {Project Name} Project Rules

## Project Overview

- **Purpose**: {プロジェクトの目的}
- **Language**: {主要言語}
- **Framework/Runtime**: {フレームワーク・ランタイム}
- **Main Features**: {主要機能}

## Language-Specific Rules

{言語固有のルール}

## Framework-Specific Rules

{フレームワーク固有のルール（該当する場合）}

## General Coding Practices

{一般的なコーディングプラクティス}

## Git Practices

{Git 関連のプラクティス}

## Project-Specific Guidelines

{プロジェクト固有のガイドライン}

## Security Considerations

{セキュリティ考慮事項}

## Testing Strategy

{テスト戦略（該当する場合）}
```

## 重要な注意点

1. **自動プロジェクト判定**

   - 複数の指標からプロジェクトタイプを総合的に判断
   - 不明な場合は基本ルール（coding.md, git.md）のみ適用

2. **ルール重複の回避**

   - 同じ内容のルールが複数ファイルにある場合は統合
   - プロジェクトに関係ないルールは除外

3. **エラーハンドリング**

   - GitHub API 制限やネットワークエラーの適切な処理
   - 既存 CLAUDE.md の保護（バックアップ作成）
   - ルールファイル取得失敗時の代替処理

4. **カスタマイズ対応**
   - プロジェクト固有の要件があれば Project-Specific Guidelines に追加
   - 既存ルールとの整合性を保つ

## 実行後の確認

- CLAUDE.md が適切に更新されているか
- プロジェクトタイプが正しく識別・反映されているか
- 必要なルールが含まれ、不要なルールが除外されているか
- ルールの重複や矛盾がないか
- プロジェクト固有の考慮事項が適切に追加されているか
