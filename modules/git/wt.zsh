# wt - git worktree wrapper
# Usage:
#   wt <pr-number|branch-name>  worktree作成 & cd
#   wt done                     push → worktree削除 → 元のディレクトリに戻る
#   wt ls                       fzfでworktree選択 → cd
#   wt rm                       fzfでworktree選択 → 削除

__wt_base_dir() {
  local root
  root=$(git rev-parse --show-toplevel 2>/dev/null) || return 1
  echo "${root}-wt"
}

__wt_is_worktree() {
  local base
  base=$(__wt_base_dir) || return 1
  [[ "$PWD" == "$base"/* ]]
}

__wt_main_dir() {
  git worktree list | head -1 | awk '{print $1}'
}

wt() {
  local subcmd="$1"
  case "$subcmd" in
    done) _wt_done ;;
    ls)   _wt_ls ;;
    rm)   _wt_rm ;;
    "")   echo "Usage: wt <pr-number|branch> | done | ls | rm" ;;
    *)    _wt_add "$subcmd" ;;
  esac
}

_wt_add() {
  local arg="$1"
  local branch

  # 数字ならPR番号として扱う
  if [[ "$arg" =~ ^[0-9]+$ ]]; then
    branch=$(gh pr view "$arg" --json headRefName -q .headRefName 2>/dev/null)
    if [[ -z "$branch" ]]; then
      echo "error: PR #${arg} が見つかりません" >&2
      return 1
    fi
  else
    branch="$arg"
  fi

  local base
  base=$(__wt_base_dir) || { echo "error: gitリポジトリ内で実行してください" >&2; return 1; }

  # ブランチ名のスラッシュをハイフンに変換してディレクトリ名にする
  local dir_name="${branch//\//-}"
  local wt_path="${base}/${dir_name}"

  if [[ -d "$wt_path" ]]; then
    echo "既存のworktreeに移動: $wt_path"
    cd "$wt_path"
    return 0
  fi

  # リモートブランチをfetchしてworktree作成
  git fetch origin "$branch" 2>/dev/null
  git worktree add "$wt_path" "$branch" 2>/dev/null \
    || git worktree add "$wt_path" "origin/$branch" 2>/dev/null \
    || { echo "error: ブランチ '$branch' でworktreeを作成できませんでした" >&2; return 1; }

  echo "worktree作成: $wt_path"
  cd "$wt_path"
}

_wt_done() {
  if ! __wt_is_worktree; then
    echo "error: worktree内で実行してください" >&2
    return 1
  fi

  local wt_path="$PWD"
  local main_dir
  main_dir=$(__wt_main_dir)

  git push origin HEAD || { echo "error: pushに失敗しました" >&2; return 1; }

  cd "$main_dir"
  git worktree remove "$wt_path" --force
  echo "worktree削除: $wt_path"
}

_wt_ls() {
  local selected
  selected=$(git worktree list 2>/dev/null | fzf --height=40% --prompt="Worktree > " | awk '{print $1}')
  if [[ -n "$selected" ]]; then
    cd "$selected"
  fi
}

_wt_rm() {
  local selected
  selected=$(git worktree list 2>/dev/null | fzf --height=40% --prompt="Remove worktree > " | awk '{print $1}')
  if [[ -z "$selected" ]]; then
    return
  fi
  git worktree remove "$selected" --force
  echo "worktree削除: $selected"
}
