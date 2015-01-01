Repository Structure
--------------------

I usually try to have the following files in all repos:

- Bootstrapping file: .bootstrap.d/<filename>
- LICENSE file: .LICENSES.d/LICENSE
- gitignore: .gitignore.d/<filename>
- Other important files

Tracked Tools
-------------

Following is a list of the tools I'm using vcsh to track:

- [beets]
- [ledger]
- [ssh]: SSH configuration and public keys
- [git](https://github.com/srijanshetty/vcsh-git)
- [mr](https://github.com/srijanshetty/vcsh-mr)
- [tmux](https://github.com/srijanshetty/vcsh-tmux)
- [vim](https://github.com/srijanshetty/vcsh-vim)
- [misc](https://github.com/srijanshetty/vcsh-misc)
- [zsh](https://github.com/srijanshetty/vcsh-zsh)
- [sandbox](https://github.com/srijanshetty/vcsh-sandbox): The structure of my dev environment
- [dotfiles](https://github.com/srijanshetty/dotfiles): Documentation of my dotfiles

INSTALLATION
------------

# mr

```shell
source ~/.mrenv
```

# vim

1. Run the bootstrap script

```shell
~/.bootstrap.d/vim
```

2. Run :PlugInstall from inside vim

# Dotfiles

```shell
./installer.zsh -d
```

