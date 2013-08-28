#!/bin/zsh

# Installation functions
function install_zsh {
	echo ""
	echo "********************************************************************"
	echo "************************ ZSH ***************************************"
	echo "********************************************************************"
	echo ""
	echo "Installing zsh"
	sudo apt-get install -y zsh autojump
    chsh -s /bin/zsh
}

function install_system {
	echo ""
	echo "********************************************************************"
	echo "************************ System ************************************"
	echo "********************************************************************"
	echo ""
	sudo apt-get install -y dstat htop
}

function install_essentials {
	# Install the no-brainers
	sudo apt-get install git openssh-server ia32-libs
	sudo add-apt-repository ppa:noobslab/apps && sudo apt-get update
    sudo apt-get install -y synapse
}

function install_battery {
	echo ""
	echo "********************************************************************"
	echo "************************ Battery ***********************************"
	echo "********************************************************************"
	echo ""
	sudo apt-get install -y acpi ibam
	# sudo add-apt-repository ppa:bumblebee/stable && sudo apt-get update
	# sudo apt-get install -y bumblebee virtualgl linux-headers-generic

}

function install_miscellaneous {
	echo ""
	echo "********************************************************************"
	echo "************************ Miscellaneous *****************************"
	echo "********************************************************************"
	echo ""
	sudo apt-get install -y flashplugin-installer vlc pavucontrol
}

function install_indicators {
	echo ""
	echo "********************************************************************"
	echo "************************ UI Components *****************************"
	echo "********************************************************************"
	echo ""
	# Repositories 
	sudo add-apt-repository ppa:noobslab/indicators && sudo apt-get update
	
	# Indicators
	sudo apt-get install -y lm-sensors hddtemp fluxgui indicator-sensors
}

function install_vim { 
	# Install vim, then copy config files
	echo ""
	echo "********************************************************************"
	echo "************************ Vim ***************************************"
	echo "********************************************************************"
	echo ""
	if sudo apt-get install -y vim; then
        config_vim
	fi
}

function install_xmonad {
	# Install gnome, followed by xmonad and then copy the config files. After this step, we compile xmonad
	sudo apt-get -y install gnome-panel
	echo ""
	echo "********************************************************************"
	echo "************************ Xmonad ************************************"
	echo "********************************************************************"
	echo ""
	if sudo apt-get install -y xmonad; then
        config_xmonad
	fi
}

# Configuration Functions
function config_synapse {
    cd ~/.config
    if [[ -e synapse ]]; then
        echo "Synapse configuration exists"
    else
        ln -s "${CONFDIR}/config/synapse" .
    fi
    cd $CONFDIR
}

function config_git {
    # Git configuration
    git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"""
    git config user.name "Srijan R Shetty"
    git config user.email "srijan.shetty@gmail.com"
}

function config_zsh {
    cd
    ln -s "${CONFDIR}/shells/zsh/zprezto" .zprezto

    setopt EXTENDED_GLOB
    for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
        ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
    done
    cd ${CONFDIR}
}

function solarize {
	echo ""
	echo "********************************************************************"
	echo "************************ SOLARIZE **********************************"
	echo "********************************************************************"
	echo ""
    
    if [ -e ~/.dircolors ]; then
        echo "Dircolors exists"
    else
        cp shells/dircolors.ansi-light ~/.dircolors
    fi
    eval `dircolors ~/.dircolors`
    shells/solarize/solarize
}

function remap {
    # Map caps lock to escape
    cd
    if [ -e .Xmodmap ]; then 
        echo "A remap file already exists. Please delete it and run --remap"
    else
        ln -s ${CONFDIR}/files/Xmodmap .Xmoadmap
    fi
    cd ${CONFDIR}
    
    #This is for xinitrc
    cd 
    if [ -e .xinitrc ]; then
        echo "A xinitrc already exists. Delete and retry"
    else
        ln -s "${CONFDIR}/files/xinitrc" .xinitrc
    fi
}

function config_vim {
    cd
    if [ -d .vim ]; then
        echo "A vim configuration already exists, delete and run --vim-config"
    else
        ln -s "${CONFDIR}/config/vim/vim" .vim
        ln -s "${CONFDIR}/config/vim/vimrc" .vimrc
    fi
    cd $CONFDIR
}

function config_xmonad {
    cd
    if [ -d .xmonad ]; then
        echo "A xmonad configuration already exists, delete and run --xmonad-config"
    else
        ln -s "${CONFDIR}/config/xmonad" .xmonad
        cd ${CONFDIR}
        xmonad --recompile
    fi
}

function config {
    config_git
    config_xmonad
    config_vim
    remap
    solarize
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
            install_system
            config;;

        -x | --xmonad) install_xmonad;;

        -X | --xmonad-config) config_xmonad;;

        -v | --vim) install_vim;;
        
        -V | --vim-config) config_vim;;

        -G | --git-config) config_git;;

        -z |--zsh) install_zsh;;

        -Z |--zsh-config) config_zsh;;
        
        --solarize) solarize;;

        -e | --essentials) install_essentials;;

        -m | --miscellaneous) install_miscellaneous ;;

        -i | --indicators) install_indicators;;

        -r | --remap) remap;;

        -c | --config) config;;
        
        -s | --system) install_system;;

        -b | --battery) install_battery;;

        *)
            echo "********************************************************************
                ***************************** HELP *********************************
                ********************************************************************

                --all             :               Installs all components
                --zsh             :               Install and configure zsh
                --vim             :               Install and configure vim
                --xmonad          :               Install and configure xmonad
                --system          :               Install system utilities 
                --battery         :               Install battery utilities 
                --remap           :               X system configuration 
                --config          :               Configure git, solarize and X
                --miscellaneous   :               Only installs additional componenets
                --ui              :               Installs indicators and synapse
                --essentials      :               Installs only essential componenets
            "
    esac
    shift
done
