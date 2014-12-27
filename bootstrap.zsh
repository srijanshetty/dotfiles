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
_EOH_
}

#configure writing tools
function config_utilities() {
    highlight "Configuring LaTeX"
    configure "LaTeX" "${CONFDIR}/config/utilites/texmf" ~/texmf
}

# Configuration Functions
function config_node() {
    if hash nvm &> /dev/null;then
        if nvm install stable && nvm use stable; then
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

        -u | --utilities)
            config_utilities;;

        -r | --remap)
            config_remap;;

        -d | --dir)
            setup_dir;;

       * )
            help_text;;

    esac
    shift
done
