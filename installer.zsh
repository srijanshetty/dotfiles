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
    -o | --elementary-os               Elementary OS
    -i | --indicators                  flux, hddtemp, sensors, sysmon, weather, synapse, calendar, shutter
    -m | --music                       beets, vlc, pavucontrol, id3tool
    -s | --system                      dstat, htop, iotop, trash, tree
    -u | --utilities                   texlive, pandoc, ledger, git-annex, zathura, mr, keybase
    -b | --battery                     acpi, bumbleebee, tlp
    -d | --devel                       curl, npm-tools, haskell-tools, c-tools, rvm, python-tools
    -x | --xmonad                      xmonad
    -r | --remap                       Remap keys
    --fun                              cowsay, fortune
    --sync                             onedrive, copy, dropbox, btsync
_EOH_
}

# Test functions
function test_function() {
    highlight "\nRunning test function"
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

# Latest essentials
function install_latest() {
    # Add git repo
    # Add tmux repo
    # Add vim repo
    # g++
    add-ppa ubuntu-toolchain-r/test && sudo apt-get update
}

# Utilities for Elementary OS
function install_elementary() {
    highlight "\nInstalling Elementary Utilities"

    # For most features
    add-ppa versable/elementary-update
    add-ppa heathbar/super-wingpanel

    installer elementary-tweaks || ERR=1
    installer super-wingpanel || ERR=1
    installer indicator-synapse || ERR=1
    installer elementary-wallpaper-collection || ERR=1
    installer dconf-editor || ERR=1

    # install conky-manager
    add-ppa teejee2008/ppa && sudo apt-get update
    installer conky-manager
    highlight "\nInstall themes from http://www.teejeetech.in/2014/06/conky-manager-v2-themes.html"

    # Y PPA Manager
    add-ppa webupd8team/y-ppa-manager && sudo apt-get update
    installer y-ppa-manager || ERR=1
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
    # installer gnome-panel || ERR=1
    # installer xmonad || ERR=1
}

# System monitoring utilies
function install_system() {
    highlight "\nInstalling System Utilities: dstat, htop, iotop, tree, trash"

    installer dstat || ERR=1
    installer htop || ERR=1
    installer iotop || ERR=1
    installer tree || ERR=1
    npm-install trash || ERR=1
}

# Utilities
function install_utilities() {
    highlight "\nInstalling Utilities: TeX, pandoc, zathura, ledger, git-annex, mr, keybase"

    installer -n latex -p texlive || ERR=1
    installer -n xelatex -p texlive-xetex || ERR=1
    installer pandoc || ERR=1
    installer zathura || ERR=1

    # PPA for ledger
    add-ppa mbudde/ledger && sudo apt-get update
    installer ledger || ERR=1

    # Git annex
    add-ppa fmarier/git-annex && sudo apt-get update
    installer git-annex

    # Install keybase
    npm-install keybase-installer || ERR=1
}

# devel tools
function install_devel_tools() {
    highlight "\nInstalling devel tools: curl, npm-tools, haskell-tools, c-tools, rvm, python-tools"

    # General Utilities
    installer curl || ERR=1

    # Development on NodeJS
    npm-install yo || ERR=1
    npm-install gulp || ERR=1
    npm-install nodemon || ERR=1

    # Haskell and cabal
    installer ghc || ERR=1
    installer cabal-install || ERR=1

    # For C
    installer cmake || ERR=1
    installer build-essential || ERR=1
    installer autoconf || ERR=1
    installer automake || ERR=1
    installer apt-file || ERR=1
    installer exuberant-ctags || ERR=1
    installer cscope || ERR=1

    # RVM
    install-rvm || ERR=1

    # Python
    install-pip || ERR=1
    installer ipython || ERR=1
    installer python-dev || ERR=1

    # For Python3
    # For Python3.3 onwards
    # add-ppa fkrull/deadsnakes && sudo apt-get update
    # installer python3.4 || ERR=1

    # Pip tools
    pip-install virtualenv || ERR=1
    pip-install virtualenvwrapper || ERR=1
    pip-install pygments || ERR=1
    pip-install sphinx || ERR=1
}

# For the love of music
function install_music () {
    # Dependencies of beets for various plugins
    highlight "\nInstalling music tools: beets, vlc, pavucontrol, id3tool"
    pip-install pylast || ERR=1
    pip-install flask || ERR=1
    pip-install beets || ERR=1

    # For music
    installer pavucontrol || ERR=1
    installer vlc || ERR=1
    install ubuntu-restricted-extras || ERR=1
    installer id3tool || ERR=1
}

# Tools for making sure ubuntu doesn't kill my battery
function install_battery() {
    highlight "\nInstalling battery monitoring utilies: acpi"

    # Monitoring tools
    installer acpi || ERR=1

    highlight "\nUncomment bumblebee and tlp"

    # Adding repos for bumblebee
    # add ppa bumblebee/stable && sudo apt-get update
    # sudo apt-get install bumblebee bumblebee-nvidia virtualgl linux-headers-generic

    # tlp
    # add-ppa linrunner/tlp && sudo apt-get update
    # sudo apt-get install tlp tlp-rdw
    # sudo tlp start
}

# have to keep a check on the temparature of the laptop
function install_indicators() {
    highlight "\nInstalling indicators: lm-sensors, hddtemp, flux, calendar, sysmon, sensors, shutter"

    # the sensors which are required
    installer lm-sensors || ERR=1
    installer hddtemp || ERR=1
    installer fluxgui || ERR=1

    # the indicator for sensors
    add-ppa nilarimogard/webupd8 && sudo apt-get update

    # Indicator for calendar
    add-ppa atareao/atareao && sudo apt-get update
    installer calendar-indicator

    add-ppa fossfreedom/indicator-sysmonitor && sudo apt-get update
    installer indicator-sysmonitor || ERR=1

	add-ppa noobslab/indicators && sudo apt-get update
    installer my-weather-indicator || ERR=1

    add-ppa alexmurray/indicator-sensors && sudo apt-get update
    installer indicator-sensors || ERR=1

    add-ppa ppa:shutter/ppa && sudo apt-get update
    installer shutter || ERR=1
}

function install_fun() {
    highlight "\nInstalling fun tools: fotune-mod, cowsay"
    # for fortune
    installer fortune-mod || ERR=1

    # Cow commit
    installer cowsay || ERR=1
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

        -x | --xmonad)
            install_xmonad;;

        -e | --essentials)
            install_essentials;;

        -o | --elementary-os)
            install_elementary;;

        -m | --music)
            install_music;;

        -i | --indicators)
            install_indicators;;

        -s | --system)
            install_system;;

        -b | --battery)
            install_battery;;

        -w | --utilities)
            install_utilities;;

        -d | --devel)
            install_devel_tools;;

        -r | --remap)
            config_remap;;

        --fun)
            install_fun;;

        -t | --test)
            test_function;;

        * )
            help_text;;

    esac
    shift
done

#Return the error
exit $ERR
