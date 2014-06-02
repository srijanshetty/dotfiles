#!/bin/zsh

function help_text() {
cat << _EOH_

USAGE: installer <arguments>

Available options:

    -f | --full                        Full Installations
    -a | --ack                         Install ack
    -n | --nvm                         Install NVM
    -at| --autojump                    Install autojump
    -g | --github                      tmux-networkspeed, sysadmin
    -x | --xmonad                      Install xmonad
    -e | --essentials                  zsh, ack, git, vim, tmux, nvm
    -m | --miscellaneous               flash, vlc, music, ssh, 32-bit support, synapse
    -i | --indicators                  flux, hddtemp, lm-sensors, indicator-sensor, indicator-sysmon
    -s | --system                      dstat, htop
    -b | --battery                     ibam, bumblebee, acpi, jupiter
    -w | --write                       texlive, pandoc
    -d | --devel                       curl, nvm, ipython, yo
    --build                            g++, make, pip
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
        echo "Success" &> /dev/null
    else
        if wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.6.1/install.sh | sh - ; then
            success "NVM installed"
        else
            fail "NVM"
            ERR=1
        fi
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
    if [ -f ~/Documents/GitHub ]; then
        cd ~/Documents/GitHub
    else
        mkdir -p ~/Documents/GitHub; cd ~/Documents/GitHub
    fi

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
    if [ ! -d tmux-networkspeed ]; then
        git clone https://github.com/skx/sysadmin-util sysadmin
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
    highlight "\nInstalling build tools: pip, python-setuptools"

    # python-setuptools is for easy_install
    installer python-setuptools
    installer pip
}

# Write tools
function install_write_tools() {
    highlight "\nInstalling write tools: TeX, pandoc"
    installer texlive
    installer pandoc
}

# devel tools
function install_devel_tools() {
    highlight "\nInstalling devel tools: curl, ipython, yo"
    installer curl
    installer ipython
    npm_install yo
}

# Tools for making sure ubuntu doesn't kill my battery
function install_battery {
    highlight "\nInstalling battery monitoring utilies"

    # Monitoring tools
    installer acpi
    installer ibam

    # Bumblee the saviour of poor nVidia card laptops running linux
	# sudo add-apt-repository ppa:bumblebee/stable && sudo apt-get update
    installer bumblebee
    installer virtualgl
    installer linux-headers-generic

    # Install jupiter for performance control
    #sudo add-apt-repository ppa:webupd8team/jupiter && sudo apt-get update
    installer jupiter
}

# have to keep a check on the temparature of the laptop
function install_indicators {
    # the sensors which are required
    installer lm-sensors
    installer hddtemp
    installer fluxgui

    # the indicator for sensors
	# sudo add-apt-repository ppa:noobslab/indicators && sudo apt-get update
    # sudo add-apt-repository ppa:nilarimogard/webupd8 && sudo apt-get update
    # sudo add-apt-repository ppa:jconti/recent-notifications && sudo apt-get update
    installer indicator-sensors
    installer indicator-sysmonitor
    installer indicator-weather
    installer indicator-multiload
    installer indicator-notifications
    installer recent-notifications
}

function install_music () {
    installer pavucontrol
    installer vlc

    # Dependencies of beets for various plugins
    # pip install pylast
    # pip install flask
    # pip install beets

}

function install_miscellaneous {
    # simple utilies like SSH, compatibility tools
    installer openssh-server
    installer ia32-libs

    # Synapse for immediate execution
	# sudo add-apt-repository ppa:noobslab/apps && sudo apt-get update
    installer synapse

    # Y PPA Manager
    # sudo add-apt-repository ppa:webupd8team/y-ppa-manager && sudo apt-get update
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
