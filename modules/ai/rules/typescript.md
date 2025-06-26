# TypeScript コーディングルール

## 基本原則
- 型定義は interface ではなく、type を使用する
- for よりも map などの method を優先して使用する
- できるだけ let は使わず、const を使用
- 外部で使われていない場合は export しない
- 使用していない import や変数は削除

## インポート・エクスポート
- ES Modules 使用時は .js 拡張子を明示してインポート
- 相対パス指定時は一貫したベースパスを使用
- デフォルトエクスポートよりも名前付きエクスポートを優先

## React/TUI固有ルール
- useState, useEffect などのHooksは適切に依存配列を指定
- useInput などのinkライブラリのHooksも同様に依存関係を管理
- React コンポーネントの Props は `[ComponentName]Props` 形式で命名

## 型安全性
- any型の使用を避け、適切な型定義を行う
- オプショナル型は `?:` を使用
- Union types で状態を明確に表現
- 配列アクセス時は bounds check を実装

## エラーハンドリング
- Promise ベースの処理では適切な catch を実装
- 型ガードを使用して実行時型チェックを行う
- Error 型を継承したカスタムエラークラスを定義
