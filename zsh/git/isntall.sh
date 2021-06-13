# backup
echo "old version"
git --version
sudo mv /usr/bin/git /usr/bin/git-apple

brew install git
brew link --force git
exec $SHELL -l

echo "new version"
git --version

ln -snf "$(cd "$(dirname "${BASH_SOURCE:-$0}")" && pwd)/gitconfig" "$HOME/.gitconfig"
