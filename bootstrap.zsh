#!/bin/zsh


# Store the configuration directory for use by the functions
CONFDIR="$(dirname "$0")"
[ -z $DOT_HELPER ] && source "${CONFDIR}/helpers/helper.sh"
[ -z $DOT_CONFIGURE ] && source "${CONFDIR}/helpers/configure.zsh"

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
    -u | --utilities            configure writing tools
    -m | --music-config         configure beets
    -d | --setup-dir            setup the directory structure
    --config-ssh                configure ssh
_EOH_
}

# Vim configuration
function config_vim() {
    highlight "\nConfiguring Vim"
    configure "VIM" "${CONFDIR}/config/vim-plug/vim/"  ~/.vim || ERR=1
    configure "VIM" "${CONFDIR}/config/vim-plug/vimrc" ~/.vimrc || ERR=1
}

# Git configuration
function config_git() {
    highlight "\nConfiguring git"
    configure "GIT" "${CONFDIR}/config/git/gitconfig" ~/.gitconfig || ERR=1
    configure "GIT" "${CONFDIR}/config/git/gitignore_global" ~/.gitignore_global || ERR=1
    configure "GIT" "${CONFDIR}/config/git/mrconfig" ~/.mrconfig || ERR=1

    # setup the directory structure
    setup_dir
}

#Configuration file for tmux
function config_tmux() {
    highlight "\nConfiguring tmux"
    configure "TMUX" "${CONFDIR}/config/tmux.conf" ~/.tmux.conf
}

# Configure music
function config_music() {
    highlight "\nConfiguring Beets"
    configure "BEETS" "${CONFDIR}/config/beets" ~/.config/beets
}

#configure writing tools
function config_utilities() {
    highlight "Configuring LaTeX, Ledger"
    configure "LaTeX" "${CONFDIR}/config/texmf" ~/texmf
    configure "LEDGER" "${CONFDIR}/utitilies/ledgerrc" ~/.ledgerrc
}

#Configure xmonad
function config_xmonad() {
    highlight "\nConfiguring xmonad"
    configure "XMONAD" "${CONFDIR}/config/xmonad" ~/.xmonad && xmonad --recompile
    configure "XINITRC" "${CONFDIR}/config/system/xinitrc" ~/.xinitrc
}

# configure ssh
function config_ssh() {
    highlight "\nConfiguring ssh"
    configure "SSH" "${CONFDIR}/config/system/sshconfig" ~/.ssh/config
}

#ZSH configuration
function config_zsh() {
    highlight "\nConfiguring zsh"

    # change default shell to zsh
    if [ -n $ZSH_NAME ]; then
        success "The current shell is zsh"
    else
        chsh -s /bin/zsh && success "Changed the shell to zsh"
    fi

    configure "ZSH" "${CONFDIR}/shells/zsh/zprezto" ~/.zprezto

    setopt EXTENDED_GLOB
    for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
        ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
    done
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

#setup the directories
function setup_dir() {
    if [ ! -d $GITHUB_DIR ]; then
        if mkdir -p $GITHUB_DIR; then
            success "Created GitHub directory at $GITHUB_DIR"
        else
            fail "Creation of GitHub directory failed at $GITHUB_DIR"
        fi
    else
        warn "GitHub directory exists at $GITHUB_DIR"
    fi

    if [ ! -d $LOCAL_BIN ]; then
        if mkdir -p $LOCAL_BIN; then
            success "Created local directory at $LOCAL_BIN"
        else
            fail "Creation of local directory failed at $LOCAL_BIN"
        fi
    else
        warn "Local directory exists at $LOCAL_BIN"
    fi
}

# Install everything
function config_full() {
}

# In case the argument list is empty
if [ -z "$1" ]; then
    help_text
fi

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

        --test)
            tester;;

        -d | --setup-dir)
            setup_dir;;

       * )
            help_text;;

    esac
    shift
done
