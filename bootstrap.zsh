#!/bin/zsh

# Store the configuration directory for use by the functions
DOT_DIR_NAME="$(dirname $0)"
[ -z $DOT_HELPER ] && source "${DOT_DIR_NAME}/scripts/helper.sh"
CONFDIR="$PWD"

#Help text
function help_text() {
cat <<- _EOH_

USAGE: bootstrap.sh <arguments>

Available commands:

    -f | --full                 Install all options
    -v | --vim-config           configure only vim
    -g | --git-config           configure git
    -z | --zsh-config           configure zsh using Prezto
    -n | --node-configure       configure node
    -t | --tmux-config          configure tmux
    -r | --remap-config         configure remap of keys
    -x | --xmonad-config        configure only xmonad
    -u | --utilities            configure writing tools: LaTeX, ledger
    -m | --music-config         configure beets
    --config-ssh                configure ssh
    --config-sublime            configure sumblime text
    --config-bare               bare bones configuration
    -solarize                  solarize the terminal
_EOH_
}

# Vim configuration
function config_vim() {
    highlight "\nConfiguring Vim"

    if hash vim &> /dev/null; then
        if [ -d ~/.vim ]; then
            fail "vim : delete ~/.vim and retry"
            return 1
        else
            if ln -s "${CONFDIR}/config/vim-plug/vim" ~/.vim && ln -s "${CONFDIR}/config/vim-plug/vimrc" ~/.vimrc; then
                success "vim : configured"
                return 0
            else
                fail "vim : failed to create symlinks"
                return 1
            fi
        fi
    else
        fail "vim : install vim"
        return 1
    fi
}


# Git configuration
function config_git() {
    highlight "\nConfiguring git"

    if hash git &> /dev/null; then
        # Configure git
        if [ -e ~/.gitconfig ]; then
            fail "git : delete ~./gitconfig and retry"
            return 1
        else
            if ln -s "${CONFDIR}/config/git/gitconfig" ~/.gitconfig; then
                success "git : configured."
            else
                fail "git : failed to create symlinks"
                return 0
            fi
        fi

        # Configure global gitignore
        if [ -e ~/.gitignore_global ]; then
            fail "git : ~/.gitignore_global and retry"
            return 1
        else
            if ln -s "${CONFDIR}/config/git/gitignore_global" ~/.gitignore_global; then
                success "git : global gitignore configured"
                return 0
            else
                fail "git : failed to create symlinks"
                return 1
            fi
        fi
    else
        fail "git : install git"
        return 1
    fi
}

#ZSH configuration
function config_zsh() {
    highlight "\nConfiguring zsh"

    if hash zsh &> /dev/null; then
        if [ -d ~/.zprezto ]; then
            fail "Prezto : delete ~/.zprezto and retry"
            return 1
        else
            # change default shell to zsh
            if [ -n $ZSH_NAME ]; then
                warn "The current shell is zsh"
            else
                chsh -s /bin/zsh
            fi

            ln -s "${CONFDIR}/shells/zsh/zprezto" ~/.zprezto
            setopt EXTENDED_GLOB
            for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
                ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
            done

            success "Prezto : configured"
            return 0
        fi
    else
        fail "zsh : install zsh"
        return 1
    fi
}

#Configuration file for tmux
function config_tmux() {
    highlight "\nConfiguring tmux"

    if hash tmux; then
        if [ -e ~/.tmux.conf ]; then
            fail "tmux : delete ~/.tmux.conf and retry"
            return 1
        else
            if ln -s "${CONFDIR}/config/tmux.conf" ~/.tmux.conf; then
                success "tmux : configured"
                return 0
            else
                fail "tmux : Symlink failure"
                return 1
            fi
        fi
    else
        fail "tmux : install tmux"
        return 1
    fi
}

# Configuration Functions
function config_node() {
    if hash nvm &> /dev/null;then
        if nvm install v0.10.28 && nvm use v0.10.28; then
            success "NVM : configured"
            return 0
        else
            fail "NVM : Error with NVM script"
            return 1
        fi
    else
        fail "NVM : nvm not installed"
        return 1
    fi
}
# Configure music
function config_music() {
    highlight "\nConfiguring Beets"

    if hash beet &> /dev/null; then
        if [ -d ~/.config/beets ]; then
            fail "Beets : delete ~/.config/beets and retry"
            return 1
        else
            if ln -s "${CONFDIR}/config/beets" ~/.config/beets;then
                success "Beets : configured"
                return 0
            else
                fail "Beets : symbolic link failure"
                return 1
            fi
        fi
    else
        fail "beets : install beet"
        return 1
    fi
}

#configure writing tools
function config_utilities() {
    highlight "Configuring LaTeX, Ledger"

    if hash pdflatex &> /dev/null; then
        if [ -d ~/texmf ]; then
            fail "LaTex : Delete ~/texmf and retry"
            return 1
        else
            if ln -s "${CONFDIR}/config/texmf" ~/texmf;then
                success "LaTeX : configured"
                return 0
            else
                fail "LaTex : symbolic link failure"
                return 1
            fi
        fi
    else
        fail "LaTeX : install pdflatex"
        return 1
    fi

    if hash ledger &> /dev/null; then
        if [ -f ~/.ledgerrc ]; then
            fail "Ledger : Delete ~/.ledgerrc and retry"
            return 1
        else
            if ls -s "${CONFDIR}/utitilies/ledgerrc" ~/.ledgerrc; then
                success "Ledger : configured"
                return 0
            else
                fail "Ledger : symbolic link failure"
                return 1
            fi
        fi
    else
        fail "Ledger : install ledger"
        return 1
    fi
}

#Configure xmonad
function config_xmonad() {
    highlight "\nConfiguring xmonad"

    if hash xmonad &>/dev/null ; then
        if [ -d ~/.xmonad ]; then
            fail "Xmonad : Delete ~/.xmonad and retry"
            return 1
        else
            if ln -s "${CONFDIR}/config/xmonad" ~/.xmonad && xmonad --recompile; then
                success "Xmonad : configured"
                return 0
            else
                fail "Xmond : symbolic link failure"
                return 1
            fi
        fi
    else
        fail "xmonad : Install xmonad"
        return 1
    fi

    config_xinitrc
}

# Remap directly
function config_remap() {
    highlight "\nConfiguring xmodmap"

    # Map caps lock to escape
    if dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:escape']"; then
        success "Remap : successful"
        return 0
    else
        fail "Remap : failed"
        return 1
    fi
}

#Solarize the terminal
function config_solarize() {
    highlight "\nConfiguring the color scheme"

    if [ -e ~/.dircolors-light ]; then
        fail "Solarize : Delete ~/.dircolors and retry"
        return 1
    else
        cp shells/dircolors.ansi-light ~/.dircolors-light
        cp shells/dircolors.ansi-dark ~/.dircolors-dark
        eval `dircolors ~/.dircolors-light`
        shells/solarize/install.sh
        success "Solarize configured"
    fi
}

#This is for xinitrc
function config_xinitrc() {
    highlight "\nConfiguring xinitrc"

    if [ -e ~/.xinitrc ]; then
        fail "Xinitrc : Delete ~/.xinitrc and retry"
        return 1
    else
        if ln -s "${CONFDIR}/config/system/xinitrc" ~/.xinitrc;then
            success "Xinitrc : configured"
            return 0
        else
            fail "Xinitrc : symbolic link failure"
            return 1
        fi
    fi
}

# Configure sublime text
function config_sublime() {
    highlight "\nConfiguring sublime text"

    # Stub
}

# configure ssh
function config_ssh() {
    highlight "\nConfiguring ssh"

    if [ ! -d ~/.ssh ]; then
        mkdir ~/.ssh
    fi

    if [ -f ~/.ssh/config ]; then
        fail "SSH : Remove ~/ssh/config and retry."
        return 1
    else
        if ln -s "${CONFDIR}/config/system/sshconfig" ~/.ssh/config;then
            success "SSH : configured"
            return 0
        else
            fail "SSH : symbolic link failure"
            return 1
        fi
    fi
}

# Autoinstallers
# Install only essential stuff
function config_bare() {
    config_git
    config_zsh
    config_vim
    config_ssh
    config_tmux
}

# Install everything
function config_fll() {
    config_bare
    config_remap
    config_solarize
    config_xmonad
    config_sublime
    config_utilities
    config_music
}

# Here we process all the command line arguments passed to the bootstrapper
while [ -n "$1" ]; do
    case "$1" in
        -x | --xmonad-config)
            config_xmonad;;

        -v | --vim-config)
            config_vim;;

        -n | --node-config)
            config_node;;

        -g | --git-config)
            config_git;;

        -z | --zsh-config)
            config_zsh;;

        -t | --tmux-config)
            config_tmux;;

        -m | --music-config)
            config_music;;

        -u | --utilities)
            config_utilities;;

        -f | --full)
            config_full;;

        -r | --remap-config)
            config_remap;;

        --config-ssh)
            config_ssh;;

        --config-sublime)
            config_sublime;;

        --config-bare)
            config_bare;;

        --solarize)
            config_solarize;;

        --test)
            tester;;

        -h | --help)
            help_text;;

    esac
    shift
done
