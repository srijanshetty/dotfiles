#!/bin/zsh
function install_zsh {
	sudo apt-get install -y zsh 
    chsh -s /bin/zsh
}

function install_system {
	sudo apt-get install -y dstat htop
}

function install_essentials {
	# Install the no-brainers
	sudo apt-get install git openssh-server ia32-libs
	sudo add-apt-repository ppa:noobslab/apps && sudo apt-get update
    sudo apt-get install -y synapse
}

function install_battery {
	sudo apt-get install -y acpi ibam
	# sudo add-apt-repository ppa:bumblebee/stable && sudo apt-get update
	# sudo apt-get install -y bumblebee virtualgl linux-headers-generic

}

function install_miscellaneous {
	sudo apt-get install -y flashplugin-installer vlc pavucontrol
}

function install_indicators {
	# Repositories 
	sudo add-apt-repository ppa:noobslab/indicators && sudo apt-get update
	
	# Indicators
	sudo apt-get install -y lm-sensors hddtemp fluxgui indicator-sensors
}

function install_vim { 
	# Install vim, then copy config files
    sudo apt-get install vim
}

function install_xmonad {
	# Install gnome, followed by xmonad and then copy the config files. After this step, we compile xmonad
	sudo apt-get -y install gnome-panel xmonad
}

CONFDIR=${PWD}
while [ -n "$1" ]; do
    case "$1" in 
        -a | --all )
            install_vim
            install_zsh
            install_xmonad
            install_essentials
            install_indicators
            install_battery
            install_system;;

        -x | --xmonad) install_xmonad;;

        -v | --vim) install_vim;;
        
        -z |--zsh) install_zsh;;

        -e | --essentials) install_essentials;;

        -m | --miscellaneous) install_miscellaneous ;;

        -i | --indicators) install_indicators;;

        -s | --system) install_system;;

        -b | --battery) install_battery;;

        *) echo "In progress";;
    esac
    shift
done
