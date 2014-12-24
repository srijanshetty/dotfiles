#!/bin/zsh

# Store the configuration directory for use by the functions
CONFDIR=${PWD}
[ -z $DOT_HELPER ] && source "${CONFDIR}/helpers/helper.sh"
[ -z $DOT_CONFIGURE ] && source "${CONFDIR}/helpers/configure.zsh"

#Help text
function help_text() {
cat <<- _EOH_

USAGE: bootstrap.sh <arguments>

Available commands:

    -t | --test                 Test
    -z | --zsh                  configure zsh using Prezto
    -n | --node                 configure node
    -r | --remap                configure remap of keys
    -u | --utilities            configure writing tools
    -m | --music                configure beets
    -d | --dir                  setup the directory structure
    -s | --ssh-config           configure ssh
_EOH_
}

# Configure music
function config_music() {
    highlight "\nConfiguring Beets"
    configure "BEETS" "${CONFDIR}/config/music/beets" ~/.config/beets
}

#configure writing tools
function config_utilities() {
    highlight "Configuring LaTeX, Ledger"
    configure "LaTeX" "${CONFDIR}/config/utilites/texmf" ~/texmf
    configure "LEDGER" "${CONFDIR}/utitilies/ledgerrc" ~/.ledgerrc
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
    configure "ANTIGEN" "${CONFDIR}/config/zsh/bundles" ~/.zsh/bundles

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
    highlight "\nConfiguring remap of keys"

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
    if [ ! -d $LOCAL_BIN ]; then
        if mkdir -p $LOCAL_BIN; then
            success "Created local bin at $LOCAL_BIN"
        else
            fail "Creation of local bin failed at $LOCAL_BIN"
        fi
    else
        warn "Local bin exists at $LOCAL_BIN"
    fi

    if [ ! -d $SANDBOX_DIR ]; then
        if mkdir -p $SANDBOX_DIR; then
            success "Created sandbox at $SANDBOX_DIR"
        else
            fail "Creation of sandbox failed at $SANDBOX_DIR"
        fi
    else
        warn "Sandbox exists at $SANDBOX_DIR"
    fi
}

# In case the argument list is empty
if [ -z "$1" ]; then
    help_text
fi

# Here we process all the command line arguments passed to the bootstrapper
while [ -n "$1" ]; do
    case "$1" in
        -t | --test)
            tester;;

        -n | --node)
            config_node;;

        -z | --zsh)
            config_zsh;;

        -m | --music)
            config_music;;

        -u | --utilities)
            config_utilities;;

        -r | --remap)
            config_remap;;

        -s | --ssh)
            config_ssh;;

        -d | --dir)
            setup_dir;;

       * )
            help_text;;

    esac
    shift
done
