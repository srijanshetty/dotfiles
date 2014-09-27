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
    -u | --utilities            configure writing tools: LaTeX, ledger
    -m | --music-config         configure beets
    -d | --setup-dir            setup the directory structure
    --config-ssh                configure ssh
_EOH_
}

# Vim configuration
function config_vim() {
    highlight "\nConfiguring Vim"
    configure-d "VIM" "${CONFDIR}/config/vim-plug/vim/"  ~/.vim || ERR=1
    configure-f "VIM" "${CONFDIR}/config/vim-plug/vimrc" ~/.vimrc || ERR=1
}


# Git configuration
function config_git() {
    highlight "\nConfiguring git"
    configure-f "GIT" "${CONFDIR}/config/git/gitconfig" ~/.gitconfig || ERR=1
    configure-f "GIT" "${CONFDIR}/config/git/gitignore_global" ~/.gitignore_global || ERR=1
    configure-f "GIT" "${CONFDIR}/config/git/mrconfig" ~/.mrconfig || ERR=1
}

#Configuration file for tmux
function config_tmux() {
    highlight "\nConfiguring tmux"
    configure-f "TMUX" "${CONFDIR}/config/tmux.conf" ~/.tmux.conf
}

# Configure music
function config_music() {
    highlight "\nConfiguring Beets"
    configure-d "BEETS" "${CONFDIR}/config/beets" ~/.config/beets
}

#configure writing tools
function config_utilities() {
    highlight "Configuring LaTeX, Ledger"
    configure-d "LaTeX" "${CONFDIR}/config/texmf" ~/texmf
    configure-d "LEDGER" "${CONFDIR}/utitilies/ledgerrc" ~/.ledgerrc
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

    configure-f "${CONFDIR}/config/system/xinitrc" ~/.xinitrc
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
function config_fll() {
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
