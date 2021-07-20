## Installation

Manually create a directory that matches the root of ghq
```bash
$ mkdir -p ~/Desktop/dev/github.com/mrsekut
$ cd ~/Desktop/dev/github.com/mrsekut
$ git clone https://github.com/mrsekut/dotfiles.git
$ cd dotfiles
```

install [just](https://github.com/casey/just)
```bash
$ bash ./just-install.sh
```

install [nix](https://github.com/NixOS/nix)
```bash
$ just nix-install
```

install [home-manager](https://github.com/nix-community/home-manager)

After moving the `.zshrc` to another location, run the following command.
```bash
$ just home-manager-install
```

## Application
home-manager
```bash
$ home-manager switch
```


## Reference

- [mrsekut-p/modular dotfiles in nix](https://scrapbox.io/mrsekut-p/modular_dotfiles_in_nix)