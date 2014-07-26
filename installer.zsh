#!/bin/zsh

# Use relative directories in sourcing
CONFDIR="$(dirname $0)"
[ -z $DOT_HELPER ] && source "${CONFDIR}/scripts/helper.sh"
[ -z $DOT_INSTALL_SCRIPTS ] && source "${CONFDIR}/scripts/install-scripts.zsh"

#For errors
ERR=0

function help_text() {
cat << _EOH_

USAGE: installer <arguments>

Available options:

    -f | --full                        Full Installations
    -at| --autojump                    Install autojump
    -s | --system                      dstat, htop
    -e | --essentials                  zsh, git, vim, tmux, nvm, ag, autojump
    -g | --github                      tmux-networkspeed, sysadmin
    -x | --xmonad                      Install xmonad
    -w | --write                       texlive, pandoc
    -i | --indicators                  flux, hddtemp, sensors, sysmon, multiload, weather, recent
    -m | --miscellaneous               flash, vlc, music, ssh, 32-bit support
    -b | --battery                     acpi, install bumbleebee, tlp and thermald yourself
    -d | --devel                       yo, haskell-platform, bower, gulp, grunt
    --build                            pip, easy_install, pytho-setuptools
    -t | --test                        Random tests
_EOH_
}

function test_function() {
    highlight "\nRunning test function"
}


# Some nifty libraries from Github
function install_from_github() {
    install_sysadmin || ERR=1
    install_tmux_networkspeed || ERR=1
    # Massrename
}

# zsh, ag, vim ,git and screen
function install_essentials() {
    highlight "\nInstalling essentials: zsh, vim, git, tmux, autojump, ag, nvm"

    installer git || ERR=1
    installer vim || ERR=1
    installer tmux || ERR=1
    installer zsh || ERR=1
    installer -n ag -p silversearcher-ag || ERR=1
    install_autojump || ERR=1
    install_nvm || ERR=1
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
    highlight "\nInstalling System Utilities: dstat, htop"

    installer dstat || ERR=1
    installer htop || ERR=1
}

# Build tools
function install_build_tools() {
    highlight "\nInstalling build tools:"

    installer -n easy_install -p python-setuptools || ERR=1
    installer -n pip -p python-pip || ERR=1
}

# Write tools
function install_write_tools() {
    highlight "\nInstalling write tools: TeX, pandoc"
    installer -n latex -p texlive || ERR=1
    installer pandoc || ERR=1
}

# devel tools
function install_devel_tools() {
    highlight "\nInstalling devel tools"

    # Development on NodeJS
    npm_install yo || ERR=1
    npm_install bower || ERR=1
    npm_install gulp || ERR=1
    npm_install grunt || ERR=1

    # Haskell and cabal
    installer haskell-platform || ERR=1
}

# Tools for making sure ubuntu doesn't kill my battery
function install_battery() {
    highlight "\nInstalling battery monitoring utilies"

    # Monitoring tools
    installer acpi || ERR=1
}

# have to keep a check on the temparature of the laptop
function install_indicators() {
    # the sensors which are required
    installer lm-sensors || ERR=1
    installer hddtemp || ERR=1
    installer fluxgui || ERR=1

    # the indicator for sensors
    add_ppa nilarimogard/webupd8 && sudo apt-get update
    add_ppa atareao/atareao && sudo apt-get update

    add_ppa fossfreedom/indicator-sysmonitor && sudo apt-get update
    installer indicator-sysmonitor || ERR=1

	add_ppa noobslab/indicators && sudo apt-get update
    installer indicator-multiload || ERR=1
    installer my-weather-indicator || ERR=1

    add_ppa alexmurray/indicator-sensors && sudo apt-get update
    installer indicator-sensors || ERR=1

    add_ppa jconti/recent-notifications && sudo apt-get update
    installer recent-notifications || ERR=1
}

function install_music () {
    installer pavucontrol || ERR=1
    installer vlc || ERR=1

    # Dependencies of beets for various plugins
    pip install pylast || ERR=1
    pip install flask || ERR=1
    pip install discogs_client || ERR=1
    pip install beets || ERR=1
}

function install_miscellaneous {
    # simple utilies like SSH, compatibility tools
    installer openssh-server || ERR=1
    installer ia32-libs || ERR=1

    # Synapse for immediate execution
	add_ppa noobslab/apps && sudo apt-get update
    installer synapse || ERR=1

    # Y PPA Manager
    add_ppa webupd8team/y-ppa-manager && sudo apt-get update
    installer y-ppa-manager || ERR=1
}

#Loop through arguments
while [ -n "$1" ]; do
    case "$1" in
        -a | --ag)
            install_ag;;

        -at| --autojump)
            install_autojump;;

        -n | --nvm)
            install_nvm;;

        -f | --full )
            install_xmonad
            install_essentials
            install_indicators
            install_battery
            install_write_tools
            install_system;;

        -x | --xmonad)
            install_xmonad;;

        -e | --essentials)
            install_essentials;;

        -m | --miscellaneous)
            install_miscellaneous ;;

        -i | --indicators)
            install_indicators;;

        -s | --system)
            install_system;;

        -b | --battery)
            install_battery;;

        -w | --write)
            install_write_tools;;

        -d | --devel)
            install_devel_tools;;

        -g | --github)
            install_from_github;;

        --build)
            install_build_tools;;

        -h | --help)
            help_text;;

        -t | --test)
            test_function;;
    esac
    shift
done

#Return the error
exit $ERR
