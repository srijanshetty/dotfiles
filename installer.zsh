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

# Test functions
function test_function() {
    highlight "\nRunning test function"
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
    highlight "\nInstalling essentials: zsh, vim, git, tmux, ag, mr, vcsh"

    installer git || ERR=1
    installer vim || ERR=1
    installer tmux || ERR=1
    installer zsh || ERR=1
    installer mr || ERR=1
    installer vcsh || ERR=1
    installer htop || ERR=1
    installer -n ag -p silversearcher-ag || ERR=1
}

# devel tools
function install_devel_tools() {
    highlight "\nInstalling devel tools: curl, build tools"

    # General Utilities
    installer curl || ERR=1

    # For C family
    installer libstdc++6.4.4-docs || ERR=1
    installer cmake || ERR=1
    installer build-essential || ERR=1
    installer autoconf || ERR=1
    installer automake || ERR=1
    installer apt-file || ERR=1
    installer exuberant-ctags || ERR=1
    installer cscope || ERR=1
    installer python-software-properties || ERR=1
    installer python-dev || ERR=1
}

# Utilities
function install_utilities() {
    highlight "\nInstalling Utilities: TeX, pandoc, zathura, ledger, git-annex, mr, keybase"

    installer -n latex -p texlive || ERR=1
    installer -n xelatex -p texlive-xetex || ERR=1
    installer -n latex-packages -p texlive-latex-extra || ERR=1             # Needed packages for latex
    installer -n latex-packages -p texlive-generic-extra || ERR=1           # Needed packages for latex
    installer -n latex-packages -p texlive-fonts-extra || ERR=1             # Needed packages for latex
    installer pandoc || ERR=1
    installer zathura || ERR=1

    # Music Utilities
    installer pavucontrol || ERR=1
    installer vlc || ERR=1
}

# have to keep a check on the temparature of the laptop
function install_indicators() {
    highlight "\nInstalling indicators: lm-sensors, hddtemp, sysmon, sensors, shutter"

    # the sensors which are required
    installer lm-sensors || ERR=1
    installer hddtemp || ERR=1
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
            install_indicators
            install_utilities;;

        -e | --essentials)
            install_essentials;;

        -u | --ubuntu)
            install_ubuntu;;

        --utils)
            install_indicators
            install_utilies;;

        -t | --test)
            test_function;;

        * )
            help_text;;
    esac
    shift
done

#Return the error
exit $ERR
