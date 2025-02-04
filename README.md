## Installation

Manually create a directory that matches the root of ghq

```bash
$ mkdir -p ~/Desktop/dev/github.com/mrsekut
$ cd ~/Desktop/dev/github.com/mrsekut
$ git clone https://github.com/mrsekut/dotfiles.git
$ cd dotfiles
```

### install [just](https://github.com/casey/just)

```bash
$ bash ./just-install.sh
```

### install [nix](https://github.com/NixOS/nix)

```bash
$ just nix-install
```

> **Note**: If `just` is not added to your `PATH`, you can run it directly using the full path. For example:
>
> ```bash
> $ /Users/<username>/.local/bin/just nix-install
> ```

> **Note**: If you already have `bash` or `zsh`, you may get an error.
>
> 1. In that case, back up `/etc/zshrc` etc. according to the error message.
> 2. After running `$ just nix-uninstall`, run `$ just nix-install` again.

### apply

```bash
$ just nix-apply
```

## Reference

- [mrsekut-p/modular dotfiles in nix](https://scrapbox.io/mrsekut-p/modular_dotfiles_in_nix)
