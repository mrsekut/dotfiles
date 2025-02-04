#!/bin/bash
# https://scrapbox.io/mrsekut-p/squash_mergeしたbranchを削除する

local targetBranch="${1:-develop}"
git checkout -q $targetBranch
git for-each-ref refs/heads/ "--format=%(refname:short)" |
  while read branch; do
    mergeBase=$(git merge-base $targetBranch $branch)
    [[ $(git cherry $targetBranch $(git commit-tree $(git rev-parse $branch^{tree}) -p $mergeBase -m _)) == "-"* ]]
    git branch -D $branch;
  done;


# TODO: まだ入っていないbranchも消える