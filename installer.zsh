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
    -o | --elementary-os               Elementary OS + essentials
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

# Utilities for Elementary OS
function install_elementary() {
    highlight "\nInstalling Elementary Utilities"

    # For most features
    add-ppa versable/elementary-update

    installer elementary-tweaks || ERR=1
    installer dconf-editor || ERR=1
}

# Online sync utilities
function install_sync() {
    # Dropbox, copy, onedrive
    highlight "\nInstalling sync tools: btsync"

    # btsync
    sh -c "$(curl -fsSL http://debian.yeasoft.net/add-btsync-repository.sh)"
    installer btsync-gui || ERR=1
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
    installer -n ag -p silversearcher-ag || ERR=1
}

# Xmonad, the tiling manager
function install_xmonad() {
    highlight "\nUncomment xmonad"

	# Install gnome, followed by xmonad and then copy the config files. After this step, we compile xmonad
    installer gnome-panel || ERR=1
    installer xmonad || ERR=1
}

# System monitoring utilies
function install_system() {
    highlight "\nInstalling System Utilities: dstat, htop, iotop, tree, trash, incron, colordiff"

    installer dstat || ERR=1
    installer htop || ERR=1
    installer iotop || ERR=1
    installer tree || ERR=1
    installer incron || ERR=1
    npm-install trash || ERR=1
}

# devel tools
function install_devel_tools() {
    highlight "\nInstalling devel tools: curl, node, haskell, c, c++, ruby, python"

    # General Utilities
    installer curl || ERR=1
    brew install fasd || ERR=1

    # Haskell and cabal
    hash cabal &> /dev/null && installer haskell-platform || ERR=1

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

    # RVM
    install-rvm || ERR=1

    # Node
    if [[ ! $+commands[node] ]]; then
        if [[ -e "$HOME/.nvm/nvm.sh" ]]; then
            source "$HOME/.nvm/nvm.sh"
            nvm install stable && nvm alias default stable
        else
            fail "nvm not found"
        fi
    fi

    # go
    if [[ ! $+commands[go] ]]; then
        if [[ -e "$HOME/.gvm/scripts/gvm" ]]; then
            source "$HOME/.gvm/scripts/gvm"
            gvm install go1.4 && gvm use go1.4 --default
        else
            fail "gvm not found"
        fi
    fi

    # python
    if [[ -s "$HOME/.pyenv/bin/pyenv" ]]; then
        path=("$HOME/.pyenv/bin" $path)
        eval "$(pyenv init -)"

        pyenv install python2.7.9
        pyenv global 2.7.9
    fi

    # Pip tools
    pip-install ipython tornado jsonschema pymzq || ERR=1
    pip-install pygments || ERR=1
    pip-install pip-tools || ERR=1
    pip-install sphinx || ERR=1
}

# For the love of music
function install_music () {
    # Dependencies of beets for various plugins
    highlight "\nInstalling music tools: beets, vlc, pavucontrol, id3tool"
    pip-install pylast || ERR=1
    pip-install flask || ERR=1
    pip-install discogs-client || ERR=1
    pip-install beets-follow || ERR=1
    pip-install beets || ERR=1

    # For music
    installer id3tool || ERR=1
}

function install_fun() {
    highlight "\nInstalling fun tools: fotune-mod, cowsay"
    # for fortune
    installer fortune-mod || ERR=1

    # Cow commit
    installer cowsay || ERR=1

    # Ascii art
    installer toilet || ERR=1
    installer toilet-fonts || ERR=1
    installer figlet || ERR=1
}

# Tools for making sure ubuntu doesn't kill my battery
function install_battery() {
    highlight "\nInstalling battery monitoring utilies: "

    highlight "\nUncomment bumblebee and tlp"

    # Adding repos for bumblebee
    # sudo apt-get install bumblebee bumblebee-

    # tlp
    # add-ppa linrunner/tlp && sudo apt-get update
    # sudo apt-get install tlp tlp-rdw
    # sudo tlp start
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

    # PPA for ledger
    # add-ppa mbudde/ledger && sudo apt-get update
    # installer ledger || ERR=1

    # Git annex
    # installer git-annex

    # Install keybase
    npm-install keybase-installer || ERR=1

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

    add-ppa fossfreedom/indicator-sysmonitor && sudo apt-get update
    installer indicator-sysmonitor || ERR=1

    add-ppa noobslab/indicators && sudo apt-get update
    installer my-weather-indicator || ERR=1

    add-ppa alexmurray/indicator-sensors && sudo apt-get update
    installer indicator-sensors || ERR=1

    add-ppa ppa:shutter/ppa && sudo apt-get update
    installer shutter || ERR=1
}

# In case the argument list is empty
if [ -z "$1" ]; then
    help_text
fi

#Loop through arguments
while [ -n "$1" ]; do
    case "$1" in
        -f | --full )
            install_music
            install_latest
            install_sync
            install_fun
            install_xmonad
            install_essentials
            install_indicators
            install_battery
            install_utilities
            install_system;;

        -e | --essentials)
            install_essentials;;

        -o | --elementary-os)
            install_elementary;;

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
