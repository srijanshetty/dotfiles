#!/bin/zsh

function help_text() {
cat << _EOF_

USAGE: apt_installer <arguments>

Available options:

    -f | --full                        Full Installations
    -a | --ack                         Install ack 
    -x | --xmonad                      Install xmonad
    -e | --essentials                  zsh, ack, git, vim and screen
    -m | --miscellaneous               flash, vlc, music, ssh, 32-bit support, synapse
    -i | --indicators                  flux, hddtemp, lm-sensors, indicator-sensor 
    -s | --system                      dstat, htop
    -b | --battery                     ibam, bumblebee, acpi, jupiter
    --build                            g++, make, python-setuptools

_EOF_
}

# Install ack
function install_ack() {
    if [ -d ${HOME}/Documents/local/bin ]; then
    else
        mkdir -p ${HOME}/local/bin
    fi
    wget -O "${HOME}/Documents/local/bin/ack" http://beyondgrep.com/ack-2.08-single-file 
    chmod u+x "${HOME}/Documents/local/bin/ack"
}

# zsh, ack, vim ,git and screen
function install_essentials {
	sudo apt-get install -y zsh git vim screen
    install_ack

    # change default shell to zsh
    chsh -s /bin/zsh
    
}

# Xmonad, the tiling manager
function install_xmonad {
	# Install gnome, followed by xmonad and then copy the config files. After this step, we compile xmonad
	sudo apt-get -y install gnome-panel xmonad
}

# Build tools
function install_build_tools {
    #python-setuptools is for easy_install
    #g++ is for c++ compilation
    sudo apt-get install -y python-setuptools g++
}

# System monitoring utilies
function install_system {
	sudo apt-get install -y dstat htop
}

# Tools for making sure ubuntu doesn't kill my battery
function install_battery {
    # Monitoring tools
	sudo apt-get install -y acpi ibam

    # Bumblee the saviour of poor nVidia card laptops running linux
	sudo add-apt-repository ppa:bumblebee/stable && sudo apt-get update
	sudo apt-get install -y bumblebee virtualgl linux-headers-generic

    # Install jupiter for performance control
    sudo add-apt-repository ppa:webupd8team/jupiter && sudo apt-get update
    sudo apt-get install jupiter
}

# have to keep a check on the temparature of the laptop
function install_indicators {
	# Repositories 
	sudo add-apt-repository ppa:noobslab/indicators && sudo apt-get update
	
	# Indicators
	sudo apt-get install -y lm-sensors hddtemp fluxgui indicator-sensors
}

function install_miscellaneous {
    # media utilies like flash
	sudo apt-get install -y flashplugin-installer vlc pavucontrol

    # simple utilies like SSH, compatibility tools
	sudo apt-get install openssh-server ia32-libs
	sudo add-apt-repository ppa:noobslab/apps && sudo apt-get update
    sudo apt-get install -y synapse
}

#colors
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)

#Store the root directory
cd ..
CONFDIR=${PWD}

#Loop through arguments
while [ -n "$1" ]; do
    case "$1" in 
        -a | --ack) 
            install_ack;;

        -f | --full )
            install_xmonad
            install_essentials
            install_indicators
            install_battery
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

        --build)
            install_build_tools;;

        -h | --help)
            help_text;;
    esac
    shift
done
