#!/bin/zsh

function help_text() {
cat << _EOF_

USAGE: apt_installer <arguments>

Available options:

-a | --all )

-x | --xmonad) install_xmonad;;

-e | --essentials  install_essentials;;

-m | --miscellaneous) install_miscellaneous ;;

-i | --indicators) install_indicators;;

-s | --system) install_system;;

-b | --battery install_battery;;

_EOF_
}

function install_system {
	sudo apt-get install -y dstat htop
}

function install_essentials {
	sudo apt-get install -y zsh git vim
    # change default shell to zsh
    chsh -s /bin/zsh
    
}

function install_battery {
	sudo apt-get install -y acpi ibam
	# sudo add-apt-repository ppa:bumblebee/stable && sudo apt-get update
	# sudo apt-get install -y bumblebee virtualgl linux-headers-generic

}

function install_miscellaneous {
	sudo apt-get install -y flashplugin-installer vlc pavucontrol

	sudo apt-get install openssh-server ia32-libs
	sudo add-apt-repository ppa:noobslab/apps && sudo apt-get update
    sudo apt-get install -y synapse
}

function install_indicators {
	# Repositories 
	sudo add-apt-repository ppa:noobslab/indicators && sudo apt-get update
	
	# Indicators
	sudo apt-get install -y lm-sensors hddtemp fluxgui indicator-sensors
}

function install_xmonad {
	# Install gnome, followed by xmonad and then copy the config files. After this step, we compile xmonad
	sudo apt-get -y install gnome-panel xmonad
}

CONFDIR=${PWD}
while [ -n "$1" ]; do
    case "$1" in 
        -a | --all )
            install_xmonad
            install_essentials
            install_indicators
            install_battery
            install_system;;

        -x | --xmonad) install_xmonad;;

        -e | --essentials) install_essentials;;

        -m | --miscellaneous) install_miscellaneous ;;

        -i | --indicators) install_indicators;;

        -s | --system) install_system;;

        -b | --battery) install_battery;;

        *) echo "In progress";;
    esac
    shift
done
