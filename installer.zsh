#!/bin/zsh

function help_text() {
cat << _EOH_

USAGE: installer <arguments>

Available options:

    -f | --full                        Full Installations
    -a | --ack                         Install ack
    -s | --system                      dstat, htop
    -e | --essentials                  zsh, ack, git, vim, tmux, nvm
    -at| --autojump                    Install autojump
    -g | --github                      tmux-networkspeed, sysadmin
    -x | --xmonad                      Install xmonad
    -w | --write                       texlive, pandoc
    -i | --indicators                  flux, hddtemp, sensors, sysmon, multiload, weather, recent
    -m | --miscellaneous               flash, vlc, music, ssh, 32-bit support
    -b | --battery                     acpi, install bumbleebee, tlp and thermald yourself
    -d | --devel                       yo, haskell-platform, bower, gulp, grunt
    --build                            pip, easy_install, pytho-setuptools
_EOH_
}

# Installation functions
function install_autojump() {
    highlight "\nInstalling autojump"

    if hash autojump &> /dev/null; then
        warn "Autojump is already installed"
    else
        if cd shells/autojump && ./install.py; then
            success "Autojump installed"
            cd ${CONFDIR}
        else
            fail "Autojump failed"
            ERR=1
        fi
    fi
}

# Install NVM
function install_nvm() {
    if hash nvm &> /dev/null; then
        warn "NVM is already installed"
    else
        wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.6.1/install.sh && sh ./install.sh
        success "NVM installed"
    fi
}

# Install ack
function install_ack() {
    if hash ack &> /dev/null; then
        warn "ack already installed"
    else
        if [ -d ${HOME}/Documents/local/bin ]; then
            echo "Success" &> /dev/null
        else
            mkdir -p ${HOME}/Documents/local/bin
        fi

        # Dowlonad the ack script
        if wget -O "${HOME}/Documents/local/bin/ack" http://beyondgrep.com/ack-2.12-single-file &>/dev/null; then
            chmod u+x "${HOME}/Documents/local/bin/ack"
            success "ack installed"
        else
            fail "ack installation"
            ERR=1
        fi
    fi
}

# Some nifty libraries from Github
function install_from_github() {
    if [ ! -f ~/Documents/GitHub ]; then
        mkdir -p ~/Documents/GitHub
    fi

    cd ~/Documents/GitHub

    # Copy tmux-networkspeed
    if [ ! -d tmux-networkspeed ]; then
        git clone https://github.com/srijanshetty/tmux-networkspeed.git
        if [ $? -eq 0 ]; then
            success "tmux-networkspeed installed"
        else
            fail "tmux-networkspeed installation failed"
            ERR=1
        fi
    else
        warn "tmux-networkspeed already exists"
    fi

    # sysadmin tools
    if [ ! -d sysadmin ]; then
        git clone https://github.com/skx/sysadmin-util.git sysadmin
        if [ $? -eq 0 ]; then
            success "sysadmin tools installed"
        else
            fail "sysadmin tools installation failed"
            ERR=1
        fi
    else
        warn "sysadmin tools already exists"
    fi

    cd -

    # massren
}

# zsh, ack, vim ,git and screen
function install_essentials() {
    highlight "\nInstalling essentials: zsh, vim, git, tmux"

    installer git
    installer vim
    installer tmux
    installer zsh
    install_nvm
    install_ack
}

# Xmonad, the tiling manager
function install_xmonad() {
    highlight "\nInstalling xmonad"

	# Install gnome, followed by xmonad and then copy the config files. After this step, we compile xmonad
    installer gnome-panel
    installer xmonad
}

# System monitoring utilies
function install_system() {
    highlight "\nInstalling System Utilities: dstat, htop"

    installer dstat
    installer htop
}

# Build tools
function install_build_tools() {
    highlight "\nInstalling build tools:"

    installer -n easy_install -p python-setuptools
    installer -n pip -p python-pip
}

# Write tools
function install_write_tools() {
    highlight "\nInstalling write tools: TeX, pandoc"
    installer -n latex -p texlive
    installer pandoc
}

# devel tools
function install_devel_tools() {
    highlight "\nInstalling devel tools"

    # Development on NodeJS
    npm_install yo
    npm_install bower
    npm_install gulp
    npm_install grunt

    # Haskell and cabal
    installer haskell-platform
}

# Tools for making sure ubuntu doesn't kill my battery
function install_battery {
    highlight "\nInstalling battery monitoring utilies"

    # Monitoring tools
    installer acpi
}

# have to keep a check on the temparature of the laptop
function install_indicators {
    # the sensors which are required
    installer lm-sensors
    installer hddtemp
    installer fluxgui

    # the indicator for sensors
    add_ppa nilarimogard/webupd8 && sudo apt-get update
    add_ppa atareao/atareao && sudo apt-get update

    add_ppa fossfreedom/indicator-sysmonitor && sudo apt-get update
    installer indicator-sysmonitor

	add_ppa noobslab/indicators && sudo apt-get update
    installer indicator-multiload
    installer my-weather-indicator

    add_ppa alexmurray/indicator-sensors && sudo apt-get update
    installer indicator-sensors

    add_ppa jconti/recent-notifications && sudo apt-get update
    installer recent-notifications
}

function install_music () {
    installer pavucontrol
    installer vlc

    # Dependencies of beets for various plugins
    pip install pylast
    pip install flask
    pip install discogs_client
    pip install beets
}

function install_miscellaneous {
    # simple utilies like SSH, compatibility tools
    installer openssh-server
    installer ia32-libs

    # Synapse for immediate execution
	add_ppa noobslab/apps && sudo apt-get update
    installer synapse

    # Y PPA Manager
    add_ppa webupd8team/y-ppa-manager && sudo apt-get update
    installer y-ppa-manager
}

# source the helper functions
source scripts/helper.sh

#Store the root directory
CONFDIR=${PWD}

#For the error code
ERR=0

#Loop through arguments
while [ -n "$1" ]; do
    case "$1" in
        -a | --ack)
            install_ack;;

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
    esac
    shift
done

#Return the error
exit $ERR
