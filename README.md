
## install

```bash
# ghqのrootと合わせるために手動でdirectoryを作る
$ mkdir -p ~/Desktop/dev/github.com/mrsekut
$ cd ~/Desktop/dev/github.com/mrsekut
$ git clone https://github.com/mrsekut/dotfiles.git

# install just
$ bash ./just-install.sh

# install nix
$ just nix-install

# install home-manager
$ just home-manager-install

```

## Reference

- [mrsekut-p/modular dotfiles in nix](https://scrapbox.io/mrsekut-p/modular_dotfiles_in_nix)