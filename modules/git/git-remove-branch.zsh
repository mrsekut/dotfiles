#!/bin/bash

# fzfを使って`git branch -d`を実行
# ctrl-iで選択し、`ctrl-d`で削除を実行
# developにmerge済みのものは`M`を付ける

show_branches() {
  (
    git branch --merged develop |
      sed -e '/^\*/d' |                 # exclude current branch
      sed -E '/develop|master/d' |      # exclude develop and master
      sed -e 's|^ | M|'                 # marked merged
    git branch --no-merged develop |
      sed -e '/^\*/d' |                 # exclude current branch
      sed -e 's|^ |  |'                 # formatting
  ) |
    cat |
    fzf --multi --reverse --print-query --expect=ctrl-d
}

while out=$(show_branches); do
  k=$(head -2 <<<"$out" | tail -1)

  if [ "$k" = ctrl-d ]; then
    sed '1,2d' <<<"$out" |
      sed -E 's/^ M|  //' |
      while read -r branch; do
        git branch -D $branch
        if [ $? -eq 0 ]; then
          results=($results $branch)
        fi
      done
    printf "\n"
    break
  fi
done
