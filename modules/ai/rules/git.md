### コミットの作成

- できるだけ小さい粒度で commit を作成する
- commit 前に、format, lint, typecheck, test を実行する

1. 変更の分析

   - 変更または追加されたファイルの特定
   - 変更の性質（新機能、バグ修正、リファクタリングなど）の把握
   - プロジェクトへの影響評価
   - 機密情報の有無確認

2. コミットメッセージの作成

   - 「なぜ」に焦点を当てる
   - 明確で簡潔な言葉を使用
   - 変更の目的を正確に反映
   - 一般的な表現を避ける

### 補足

- 可能な場合は `git commit -am`や fixup を使用
- 関係ないファイルは含めない
- 空のコミットは作成しない
- git 設定は変更しない

### コミットメッセージの例

```bash
# 新機能の追加
feat: エラー処理の導入

# 既存機能の改善
update: キャッシュ機能のパフォーマンス改善

# バグ修正
fix: 認証トークンの期限切れ処理を修正

# リファクタリング
refactor: Adapterパターンを使用して外部依存を抽象化

# テスト追加
test: エラーケースのテストを追加

# ドキュメント更新
docs: エラー処理のベストプラクティスを追加
```
