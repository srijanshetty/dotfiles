#!/bin/zsh

function help_text() {
cat << _EOF_

USAGE: apt_installer <arguments>

Available options:

    -f | --full                        Full Installations
    -a | --ack                         Install ack 
    -x | --xmonad                      Install xmonad
    -e | --essentials                  zsh, ack, git, vim and tmux
    -m | --miscellaneous               flash, vlc, music, ssh, 32-bit support, synapse
    -i | --indicators                  flux, hddtemp, lm-sensors, indicator-sensor 
    -s | --system                      dstat, htop
    -b | --battery                     ibam, bumblebee, acpi, jupiter
    -w | --write                       texlive, pandoc
    -d | --devel                       curl, localtunnel
    --build                            g++, make, pip

_EOF_
}

# a function to install something 
function apt_install() {
    if hash $1 &> /dev/null; then
        warn "$1 is already installed"
    else
        if sudo apt-get install -y $1 &>/dev/null; then
            success "$1 installed"
        else
            fail "$1 installation"
            ERR=1
        fi
    fi
}

# a function to install something 
function npm_install() {
    if hash npm &> /dev/null; then
        if hash $1 &> /dev/null; then
            warn "$1 is already installed"
        else
            if npm install -g $1 &>/dev/null; then
                success "$1 installed"
            else
                fail "$1 installation"
                ERR=1
            fi
        fi
    else
        fail "NPM not installed. Install npm and then try"
    fi
}

# Install ack
function install_ack() {
    if hash ack &> /dev/null; then
        warn "ack already installed"
    else
        if [ -d ${HOME}/Documents/local/bin ]; then

        else
            mkdir -p ${HOME}/local/bin
        fi

        # Dowlonad the ack script
        if wget -O "${HOME}/Documents/local/bin/ack" http://beyondgrep.com/ack-2.08-single-file &>/dev/null; then
            chmod u+x "${HOME}/Documents/local/bin/ack"
            success "ack installed" 
        else
            fail "ack installation"
            ERR=1
        fi
    fi
}

# zsh, ack, vim ,git and screen
function install_essentials() {
    highlight "\nInstalling ZSH, VIM, GIT, SCREEN"

    apt_install zsh
    apt_install git
    apt_install vim
    apt_install tmux
    install_ack
}

# Xmonad, the tiling manager
function install_xmonad() {
    highlight "\nInstalling xmonad"

	# Install gnome, followed by xmonad and then copy the config files. After this step, we compile xmonad
    apt_install gnome-panel
    apt_install xmonad
}

# System monitoring utilies
function install_system() {
    highlight "\nInstalling System Utilities"
    apt_install dstat
    apt_install htop
}

# Build tools
function install_build_tools {
    highlight "\nInstalling build tools"

    # python-setuptools is for easy_install
    # apt_install python-setuptools
    # apt_install rubygems
    apt_install pip
}

# Write tools
function install_write_tools() {
    highlight "\nInstalling write tools"
    apt_install texlive
    apt_install pandoc
}

# devel tools
function install_devel_tools() {
    highlight "\nInstalling devel tools"
    apt_install curl
    npm_install yo
    npm_install localtunnel
    apt_install ipython
}

# Tools for making sure ubuntu doesn't kill my battery
function install_battery {
    highlight "\nInstalling battery monitoring utilies"

    # Monitoring tools
    apt_install acpi
    apt_install ibam

    # Bumblee the saviour of poor nVidia card laptops running linux
	#sudo add-apt-repository ppa:bumblebee/stable && sudo apt-get update
	#sudo apt-get install -y bumblebee virtualgl linux-headers-generic

    # Install jupiter for performance control
    #sudo add-apt-repository ppa:webupd8team/jupiter && sudo apt-get update
    apt_install jupiter
}

# have to keep a check on the temparature of the laptop
function install_indicators {
    # the sensors which are required
    apt_install lm-sensors
    apt_install hddtemp
    apt_install fluxgui

    # the indicator for sensors
	#sudo add-apt-repository ppa:noobslab/indicators && sudo apt-get update
    # sudo add-apt-repository ppa:nilarimogard/webupd8 && sudo apt-get update
    apt_install todo-indicator
    apt_install indicator-sensors
}

function install_miscellaneous {
    # media utilies like flash
	apt_install flashplugin-installer
    apt_install vlc 
    apt_install pavucontrol

    # simple utilies like SSH, compatibility tools
    apt_install openssh-server
    apt_install ia32-libs

    # Synapse for immediate execution
	#sudo add-apt-repository ppa:noobslab/apps && sudo apt-get update
    apt_install synapse
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

        --build)
            install_build_tools;;

        -h | --help)
            help_text;;
    esac
    shift
done

#Return the error
exit $ERR
