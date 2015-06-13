Dotfiles
--------

When I started on the path of managing my dotfiles, I was naive enough to believe that my scripting abilities would let me conquer the beast that *dotfiles* are, and it took me a couple of years to realize my folly. But I've decided to mend my ways, to follow the wisdom of the ages - **UNIX way**.

Bootstrapping
-------------

```shell
sudo apt-get install -y vcsh myrepos
vcsh clone git@github.com:srijanshetty/vcsh-mr.git mr
mr up
```

Want to get down and dirty? You need to go [here](#walk-through)

Organization
------------

There are two vital pieces of the puzzle: vcsh and mr.

1. **vcsh**: The ~500 LOC of vcsh bellies it unfathomable power. Like every great UNIX utility, vcsh builds upon another great UNIX utility - *git*. Git allows for the \$GIT_DIR to be separate from the \$GIT_WORKING_TREE. What this means is that the '.git
' directory could be located in another folder and Git would still work fine. vcsh keeps all these '.git' folders in ~/.config/vcsh/repo.d/REPO_NAME.git. And the work trees are maintained in \$HOME. So, we can have multiple git directories residing within home and none of them will collide with each other. Awesome isn't it?

2. **mr**: mr allows to manage multiple repositories together. You register repositories with mr (Using *mr reg*, D'oh) and then you can execute VCS commands like push, update, checkout on them together. mr supports all popular version controls systems. (I only care about git though).

3. **Directory Structure**: The author of the vcsh work flow prescribes the following directory structure:

```txt
~/.config/mr/
    ├── available.d
    │   ├── beets.vcsh
    │   ├── git.vcsh
    │   ├── ledger.vcsh
    │   ├── misc.vcsh
    │   ├── mr.vcsh
    │   ├── template.vcsh
    │   ├── tmux.vcsh
    │   ├── vim.vcsh
    │   ├── xmonad.vcsh
    │   └── zsh.vcsh
    └── config.d
        ├── beets.vcsh -> ../available.d/beets.vcsh
        ├── git.vcsh -> ../available.d/git.vcsh
        ├── ledger.vcsh -> ../available.d/ledger.vcsh
        ├── misc.vcsh -> ../available.d/misc.vcsh
        ├── mr.vcsh -> ../available.d/mr.vcsh
        ├── tmux.vcsh -> ../available.d/tmux.vcsh
        ├── vim.vcsh -> ../available.d/vim.vcsh
        └── zsh.vcsh -> ../available.d/zsh.vcsh
```

Some salient points about this directory structure are:
- **available.d** serves as a store for different available configurations.
- active configurations are symlinked in **config.d**.
- mr acts only on the configurations listed in **config.d**.

What's wonderful about these three tools is that they were written by the same author and work together seamlessly!!

**Note**: Maintaining symlinks seemed too much of a chore for me; and so I did what any respectable programmer would do - [automate it](https://github.com/srijanshetty/custom/blob/master/functions/myrepos.zsh)

Walk-through
------------

It took me three tries - with the last one taking over a day - in a span of over 4 months to get this straight. [This](http://www.martin-burger.net/blog/unix-shell/manage-dotfiles-quickly-and-effortlessly/)) guide did wonders.

Caveat: A lot of this section is derivative of the about mentioned article.

## Adding a new repository

If you want to manage a new tool and its dotfiles with vcsh and myrepos, follow the steps given below using ack as example.

1. Create a new remote repository for the tool you want to manage with vcsh.

```shell
vcsh init ack
```

2. The URL to clone that repository might look like: *git@github.com/vcsh-ack.git*.
3. Add new myrepos config file *~/.config/mr/available.d/ack.vcsh*, which might look as follows:

```ini
[$HOME/.config/vcsh/repo.d/ack.git]
checkout = vcsh clone git@github.com:srijanshetty/vcsh-ack.git ack
```

4. Create a symbolic link to tell mr to include this repository:

```shell
cd ~/.config/mr/config.d/
ln -s ../available.d/ack.vcsh .
```

5. Commit and push your changes in your local myrepos repository:

```shell
vcsh mr add ~/.config/mr
vcsh mr commit -m "[ack] add vcsh repository"
vcsh mr push
```

7. Add the tool's dotfiles by to vcsh.

```shell
vcsh ack add .ackrc
```

9. Create, customize, and add the tool-specific excludesfile. (More info about it over here)

```shell
vcsh write-gitignore ack
vcsh ack add -f .gitignore.d/ack
vcsh write-gitignore ack
vcsh ack add .gitignore.d/ack
```

10. Commit and push your changes in your local ack repository:

```shell
vcsh ack commit -m "[Initial Commit] add initial ackrc file"
vcsh ack push
```

Yes, the initial configuration is quite complicated. But the effort is well worth what comes next.

## Reproduction of configuration

```shell
sudo apt-get install -y vcsh myrepos
vcsh clone git@github.com:srijanshetty/vcsh-mr.git
mr up
```

Bam! It's done!

## Updating a repository

The work-flow for adding new files/updating files is simple enough.

1. After updating the files or adding new files, run:

```shell
vcsh <REPO_NAME> add <FILE_NAME>
```

2. Then commit the changes and push

```shell
vcsh <REPO_NAME> commit -m "Yowza!"
vcsh <REPO_NAME> push
```

As can be seen, vcsh supports all common VCS commands. An easier work-flow is to enter a *vcsh chroot*, demonstrated as follows:

```shell
vcsh enter REPO_NAME
ga <FILE_NAME>
gcm "Yowza!"
git push
exit
```

Not only does this enable the git prompt, but also you can use those aliases that you set. Could this get any better?

## gitignore

If you tried entering the *vcsh chroot* that I just talked about and you use a git prompt (you do use it don't you), then you're in for a treat - your terminal may have frozen for a good amount of time; and if you're like me you would have given up on this vcsh business already. But fret not, such behaviour is expected. Git prompts make use of ls-files and with over 25,000 files in my \$HOME, this king of tardiness is expected.

To get around this problem, we need to define a *gitignore/excludesfile*. And through *vcsh write-gitignore*, vcsh provides us the means to do so. The generated excludesfile is a whitelist, for the ack example above, the final generated .gitignore.d/ack file is as follows

```
*
!.ackrc
!.gitignore.d/
!.gitignore.d/ack
```

The first line ignores all files in \$HOME and then starts including the files we're tracking one by one. While this is well and good for normal use-cases, it does cause you to forget adding new files. For example, the generated excludesfile for mr is

```
*
!.config
!.config/mr
!.config/mr/available.d
!.config/mr/available.d/mr.vcsh
!.config/mr/available.d/git.vcsh
!.config/mr/config.d
!.config/mr/config.d/mr.vcsh
!.config/mr/config.d/git.vcsh
!.gitignore.d/
!.gitignore.d/mr
!.mrconfig
```

Do you see the problem? Okay let me tell you, any new file in *available.d/ or config.d/* is ignored by default. So, I'd advise using the following *.gitignore.d/mr* file which tracks files by default.

```
*
!.config
!.config/mr
!.config/mr/available.d
!.config/mr/available.d/*
!.config/mr/config.d
!.config/mr/config.d/*
!.gitignore.d
!.gitignore.d/mr
!.mrconfig
```

A final note on the four sub steps required in Step 9 of [Adding a new repository].
1. Generate a gitignore file.
2. Force add the gitignore file to index, which is ignored uptill now.
3. Regenerate the gitignore file (this time it will include the gitignore file itself).
4. Add the now modified gitignore file.

Caveats
-------

1. ~~The lack a git prompt in \$HOME, is unnerving. I still need to soak it in and find a system to track changes.~~ **Update:** vcsh version 1.2 onwards supports the vcsh status command which scratches this itch.
2. All repositories need to share a common LICENSE and README files (the way git prescribes them to). Again, I need to find a way around this.
3. ~~I don't like the manual symlinking required in .config.d/. It would be much easier to have helper functions like apache provides for it's web server~~. [This](https://github.com/srijanshetty/custom/blob/master/functions/myrepos.zsh) script creates wrappers for automating most of this.

Tracked Tools
-------------

Following is a list of the tools I'm using vcsh to track:

- [beets]
- [ledger]
- [ssh]
- [code-snippets](https://github.com/srijanshetty/code-snippets)
- [git](https://github.com/srijanshetty/vcsh-git)
- [mr](https://github.com/srijanshetty/vcsh-mr)
- [tmux](https://github.com/srijanshetty/vcsh-tmux)
- [vim](https://github.com/srijanshetty/vcsh-vim)
- [zsh](https://github.com/srijanshetty/vcsh-zsh)

License
-------

This project is licensed under the terms of the [MIT LICENSE](LICENSE)
