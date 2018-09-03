#!/bin/zsh

# Use relative directories in sourcing
CONFDIR="$(dirname $0)"
[ -z "$DOT_HELPER" ] && source "${CONFDIR}/helpers/helper.sh"
[ -z "$DOT_INSTALL" ] && source "${CONFDIR}/helpers/install-scripts.zsh"

#For errors
ERR=0

function help_text() {
cat << _EOH_

USAGE: installer <arguments>

Available options:

    -t | --test                        Random tests
    -f | --full                        Full Installations (without elementary)
    -e | --essentials                  zsh, git, vim, tmux, ag, mr, vcsh
    -u | --ubuntu                      Ubuntu Utilies
    --utils                            Indicators + Utilities
_EOH_
}

# Remap directly
function install_ubuntu() {
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

# zsh, ag, vim, git and tmux
function install_essentials() {
    highlight "\nInstalling essentials: zsh, vim, git, tmux, ag, mr, vcsh, rvm"

    installer git || ERR=1
    installer vim || ERR=1
    installer tmux || ERR=1
    installer zsh || ERR=1
    installer mr || ERR=1
    installer vcsh || ERR=1
    installer htop || ERR=1
    installer -n ag -p silversearcher-ag || ERR=1
    install-rvm() || ERR=1
}

# In case the argument list is empty
if [ -z "$1" ]; then
    help_text
fi

#Loop through arguments
while [ -n "$1" ]; do
    case "$1" in
        -f | --full )
            install_ubuntu
            install_essentials
            install_utilities;;

        -e | --essentials)
            install_essentials;;

        -u | --ubuntu)
            install_ubuntu;;

        * )
            help_text;;
    esac
    shift
done

#Return the error
exit $ERR
