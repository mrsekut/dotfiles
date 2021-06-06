for f in "$(dirname "${BASH_SOURCE:-$0}")/"*"/export.zsh"
do
	echo "$f"
  source "$f"
done