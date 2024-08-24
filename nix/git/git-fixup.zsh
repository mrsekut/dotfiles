#!/bin/bash

# `git commit --fixup` の対象を fzf で選択し、その後rebaseを自動実行する

# 環境変数の設定 (デフォルト値を使用)
FILTER=${FILTER:-fzf}
MAX_LOG_COUNT=${MAX_LOG_COUNT:-30}

# stageされている変更がない場合
if git diff --cached --quiet; then
  echo "No staged changes. Use 'git add -p' to add them." >&2
  exit 1
fi

# 最新のcommit履歴を取得
commits=$(git log --oneline -n "$MAX_LOG_COUNT")
if [[ $? -ne 0 ]]; then
  echo "Failed to retrieve commit history." >&2
  exit 1
fi

# fzf でcommitを選択
selected_line=$("$FILTER" <<<"$commits")
if [[ $? -ne 0 || -z "$selected_line" ]]; then
  echo "No commit selected." >&2
  exit 1
fi

# 選択されたcommitのhashを取得
target_commit_hash=$(awk '{print $1}' <<<"$selected_line")

# fixup commitを作成
git commit --fixup "$target_commit_hash" "$@"
if [[ $? -ne 0 ]]; then
  echo "Failed to create fixup commit." >&2
  exit 1
fi

# rebase (対象commitの1個前から)
git rebase -i --autosquash "$target_commit_hash~1"
if [[ $? -ne 0 ]]; then
  echo "Rebase failed." >&2
  exit 1
fi

echo "Fixup commit and rebase completed successfully."
