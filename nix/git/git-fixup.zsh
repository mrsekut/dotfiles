#!/bin/bash

# `git commit --fixup`の対象をfzfで選択
# ref: https://qiita.com/uasi/items/57da2e4268d348b371fb

FILTER=${FILTER:-fzf}
MAX_LOG_COUNT=${MAX_LOG_COUNT:-30}

if git diff --cached --quiet; then
  commits="No staged changes. Use git add -p to add them."
  ret=1
else
  commits=$(git log --oneline -n "$MAX_LOG_COUNT")
  ret=$?
fi

if [[ "$ret" != 0 ]]; then
  headline=$(head -n1 <<<"$commits")
  if [[ "$headline" = "No staged changes. Use git add -p to add them." ]]; then
    echo "$headline" >&2
  fi
  exit "$ret"
fi

line=$("$FILTER" <<<"$commits")
[[ "$?" = 0 && "$line" != "" ]] || exit "$?"

git commit --fixup "$(awk '{print $1}' <<<"$line")" "$@"
