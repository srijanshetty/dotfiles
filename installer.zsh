# !/bin/zsh

# Use relative directories in sourcing
CONFDIR="$(dirname $0)"
[ -z $DOT_HELPER ] && source "${CONFDIR}/helpers/helper.sh"
[ -z $DOT_INSTALL ] && source "${CONFDIR}/helpers/install-scripts.zsh"
[ -z $DOT_CONFIGURE ] && source "${CONFDIR}/helpers/configure.zsh"

#For errors
ERR=0

function help_text() {
cat << _EOH_

USAGE: installer <arguments>

Available options:

    -f | --full                        Full Installations
    -e | --essentials                  zsh, git, vim, tmux, ag, mr
    -i | --indicators                  flux, hddtemp, sensors, sysmon, weather, synapse
    -m | --music                       beets, vlc, pavucontrol, plugins, id3tool
    -s | --system                      dstat, htop, iotop, trash
    -u | --utilities                   texlive, pandoc, ledger, git-annex
    -b | --battery                     acpi, bumbleebee, tlp
    -x | --xmonad                      xmonad
    -d | --devel                       yo, haskell-platform, gulp, ipython, python3, python3.4
    --fun                              cowsay, fortune
    --build                            pip, easy_install
    --sync                             onedrive,copy,dropbox,skype
    -t | --test                        Random tests
_EOH_
}

function test_function() {
    highlight "\nRunning test function"
    pip-install beets
}

function install_latest() {
    # Add git repo
    # Add tmux repo
    # Add vim repo
    # g++
    add-ppa ubuntu-toolchain-r/test && sudo apt-get update
}

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
    # For theme http://www.teejeetech.in/2014/06/conky-manager-v2-themes.html

    # Y PPA Manager
    add-ppa webupd8team/y-ppa-manager && sudo apt-get update
    installer y-ppa-manager || ERR=1
}

function install_sync() {
    # Dropbox, copy, onedrive

    # btsync
    sh -c "$(curl -fsSL http://debian.yeasoft.net/add-btsync-repository.sh)"
    installer btsync-gui || ERR=1
}

# Build tools
function install_build_tools() {
    highlight "\nInstalling build tools: pip, easy_install"

    install_pip || ERR=1
    installer python-dev || ERR=1
    installer cmake || ERR=1
    installer build-essential || ERR=1
    installer autoconf || ERR=1
    installer automake || ERR=1
    installer apt-file || ERR=1
}

# zsh, ag, vim ,git and screen
function install_essentials() {
    highlight "\nInstalling essentials: zsh, vim, git, tmux, ag, mr"

    installer git || ERR=1
    installer vim || ERR=1
    installer tmux || ERR=1
    installer zsh || ERR=1
    installer myrepos || ERR=1
    installer -n ag -p silversearcher-ag || ERR=1
}

# Xmonad, the tiling manager
function install_xmonad() {
    highlight "\nInstalling xmonad"

	# Install gnome, followed by xmonad and then copy the config files. After this step, we compile xmonad
    installer gnome-panel || ERR=1
    installer xmonad || ERR=1
}

# System monitoring utilies
function install_system() {
    highlight "\nInstalling System Utilities"

    installer dstat || ERR=1
    installer htop || ERR=1
    installer iotop || ERR=1
    installer tree || ERR=1
    npm-install trash || ERR=1
}

# Utilities
function install_utilities() {
    highlight "\nInstalling Utilities"

    installer -n latex -p texlive || ERR=1
    installer -n xelatex -p texlive-xetex || ERR=1
    installer pandoc || ERR=1

    # PPA for ledger
    add-ppa mbudde/ledger && sudo apt-get update
    installer ledger || ERR=1

    # Git annex
    add-ppa fmarier/git-annex && sudo apt-get update
    installer git-annex

    # Install mr
    installer-mr || ERR=1

    # Install keybase
    npm-install keybase-installer || ERR=1
}

# devel tools
function install_devel_tools() {
    highlight "\nInstalling devel tools"

    installer curl || ERR=1

    # Development on NodeJS
    npm-install jshintc || ERR=1

    npm-install yo || ERR=1
    npm-install gulp || ERR=1
    npm-install jshint || ERR=1
    npm-install csslint || ERR=1
    npm-install jsonlint || ERR=1
    npm-install nodemon || ERR=1

    # Haskell and cabal
    installer haskell-platform || ERR=1

    # For C
    installer exuberant-ctags || ERR=1
    installer cscope || ERR=1

    # RVM
    install-rvm || ERR=1

    # For Python3
    installer ipython || ERR=1
    installer python3 || ERR=1

    # For Python3.3 onwards
    # add-ppa fkrull/deadsnakes && sudo apt-get update
    # installer python3.4 || ERR=1
    pip-install virtualenv || ERR=1
    pip-install virtualenvwrapper || ERR=1
}

# For the love of music
function install_music () {
    # Dependencies of beets for various plugins
    highlight "\nInstalling music tools"
    pip-install pylast || ERR=1
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
    highlight "\nInstalling battery monitoring utilies"

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
    highlight "\nInstalling indicators"

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

        --fun)
            install_fun;;

        --build)
            install_build_tools;;

        -t | --test)
            test_function;;

        * )
            help_text;;

    esac
    shift
done

#Return the error
exit $ERR
