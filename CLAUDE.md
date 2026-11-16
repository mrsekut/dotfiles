# dotfiles

## ブランチ運用

- `master`: 個人用のメインブランチ。変更は原則ここにコミットする
- `herp`: 会社 PC 用のブランチ。`master` の先頭に、会社都合の変更だけをコミットとして積んだもの
  - 常に `master` に rebase して最新に保つ（merge は使わない）
  - herp 固有のコミットは `git log master..herp` で確認できる

## 変更するときのルール

1. まず「この変更は master に入れられるか？」を検討する。会社でしか使わない設定でも、個人環境を壊さないなら master に入れる
2. 会社都合で、個人環境では困る変更（破壊的変更）だけを herp に入れる
3. herp で作業中に master 向けの修正をしたら:
   - master に切り替えてコミットする（または herp 上のコミットを cherry-pick する）
   - `git rebase master herp` で herp を追従させる
4. herp 側のコミットはできるだけ少なく保つ。新しく作るより、既存の herp コミットに fixup/squash するほうを優先する
5. herp は rebase で履歴が書き換わるので、push には `--force-with-lease` を使う
6. rebase で flake.lock がコンフリクトしたら、master 側の内容は気にせず herp 側で `nix flake lock` などを使って作り直す。flake.lock をコミットしている以上コンフリクトは避けられないので、input ごとに細かく突き合わせなくてよい
