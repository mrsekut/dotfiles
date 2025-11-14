# worktreeをfzfで選択してcdする
function wtp-cd() {
  local fzf_cmd=$(which fzf)
  local selected
  selected=$(git worktree list 2>/dev/null | "$fzf_cmd" --height=40% --prompt="Worktree > " | awk '{print $1}')
  if [[ -n "$selected" ]]; then
    cd "$selected"
  fi
}

# worktreeをfzfで選択してwtp removeする（2段階選択: worktree → オプション）
function wtp-remove() {
  local fzf_cmd=$(which fzf)
  local wtp_cmd=$(which wtp)

  # worktreeを選択
  local selected
  selected=$(git worktree list 2>/dev/null | "$fzf_cmd" --height=40% --prompt="Remove worktree > ")
  if [[ -z "$selected" ]]; then
    return
  fi

  local path=$(echo "$selected" | awk '{print $1}')

  # オプションを選択
  local options=(
    "--with-branch"
    "--with-branch --force-branch"
    "--force"
    "no options"
  )
  local option=$(printf "%s\n" "${options[@]}" | "$fzf_cmd" --height=40% --prompt="Options > ")

  if [[ "$option" == "no options" ]]; then
    echo "Removing worktree: $path"
    "$wtp_cmd" remove "$path"
  else
    echo "Removing worktree with options: $path $option"
    "$wtp_cmd" remove ${=option} "$path"
  fi
}
