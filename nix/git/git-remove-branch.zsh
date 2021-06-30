# fzfを使って`git branch -d`を実行
# ctrl-iで選択し、`ctrl-d`で削除を実行
git-remove-branch() {
  local k results
  while out=$(git branch      |
              sed -e '/^\*/d' |
              fzf --multi --reverse --print-query --expect=ctrl-d); do
    k=$(head -2 <<< "$out" | tail -1)

    if [ "$k" = ctrl-d ]; then
      sed '1,2d' <<< "$out" |
      awk '{print $1}'      |
      while read -r branch
      do
        git branch -D $branch
        if [ $? -eq 0 ]; then
          results=($results $branch)
        fi
      done
      printf "\n"
      break
    fi
  done
}