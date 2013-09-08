#!/bin/zsh

# Installation functions
function install_autojump {
    # Install autojump
    if which autojump &>/dev/null; then
        echo "Autojump already exists, you will have to manually configure autojump.zsh"
    else
        cd shells/autojump
        ./install.sh
        cd ${CONFDIR}
    fi
}

# Configuration Functions
#Vim configuration
function config_vim {
    if which vim &>/dev/null; then
        cd
        if [ -d .vim ]; then
            echo "A vim configuration already exists, delete and run --vim-config"
        else
            ln -s "${CONFDIR}/config/vim/vim" .vim
            ln -s "${CONFDIR}/config/vim/vimrc" .vimrc
        fi
        cd $CONFDIR
    fi
}

# Git configuration
function config_git {
    if which git &> /dev/null; then
        git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"""
        git config --global user.name "Srijan R Shetty"
        git config --global user.email "srijan.shetty@gmail.com"
    fi
}

#ZSH configuration
function config_zsh {
    if which zsh &> /dev/null; then
        cd
        if [[ -d .zprezto ]]; then
            echo "Prezto already exists"
        else
            ln -s "${CONFDIR}/shells/zsh/zprezto" .zprezto

            setopt EXTENDED_GLOB
            for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
                ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
            done
            cd ${CONFDIR}
        fi
    fi
}

#Solarize the terminal
function solarize {
	echo ""
	echo "********************************************************************"
	echo "************************ SOLARIZE **********************************"
	echo "********************************************************************"
	echo ""
    
    if [ -e ~/.dircolors ]; then
        echo "A color configuration already Exists. Exiting."
    else
        cp shells/dircolors.ansi-light ~/.dircolors
    fi
    eval `dircolors ~/.dircolors`
    shells/solarize/solarize
}

#Synapse configuration
function config_synapse {
    if which synapse &> /dev/null; then
        cd ~/.config
        if [[ -e synapse ]]; then
            echo "Synapse configuration exists"
        else
            ln -s "${CONFDIR}/config/synapse" .
        fi
        cd $CONFDIR
    fi
}

function config_xmodmap {
    # Map caps lock to escape
    cd
    if [ -e .Xmodmap ]; then 
        echo "A remap file already exists. Please delete it and run --remap"
    else
        ln -s ${CONFDIR}/config/Xmodmap .Xmoadmap
    fi
    cd ${CONFDIR}
}

#This is for xinitrc
function config_xinitrc {
    cd 
    if [ -e .xinitrc ]; then
        echo "A xinitrc already exists. Delete and retry"
    else
        ln -s "${CONFDIR}/config/xinitrc" .xinitrc
    fi
}

#Configure xmonad
function config_xmonad {
    if which xmonad &> /dev/null; then
        cd
        if [ -d .xmonad ]; then
            echo "A xmonad configuration already exists, delete and run --xmonad-config"
        else
            ln -s "${CONFDIR}/config/xmonad" .xmonad
            cd ${CONFDIR}
            xmonad --recompile
        fi
    fi
}

#Autoinstallers
#Install everything
function config {
    config_bare
    config_xmonad
    config_xinitrc
    config_xmodmap
    config_synapse
}

#Install only essential stuff
function config_bare {
    config_git
    config_zsh
    config_vim
    solarize
    install_autojump
}

CONFDIR=${PWD}
while [ -n "$1" ]; do
    case "$1" in 
        -x | --xmonad-config) config_xmonad;;

        -v | --vim-config) config_vim;;

        -g | --git-config) config_git;;

        -z |--zsh-config) config_zsh;;
        
        -c | --config) config;;
        
        -a | --autojump) autojump;;

        --config-bare) config_bare;;
    
        --solarize) solarize;;

        --test) tester;;

        *) echo "Help function will be up soon";;
    esac
    shift
done
