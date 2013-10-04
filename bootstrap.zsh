#!/bin/zsh

#Help text
function help_text() {
cat <<- _EOF_

USAGE: bootstrap.sh <arguments>
VERSION: 1.0.0

Available commands:

-x | --xmonad-config        configure only xmonad 
-v | --vim-config           configure only vim
-g | --git-config           configure git
-z | --zsh-config           configure zsh using Prezto
-s | --screen-config        configure screen
-i | --xinitrc-config       configure xinitrc 
-y | --synapse-config       configure synapse
-r | --remap-config         configure xmodmap 
-a | --autojump             Install autojump
-c | --config               apply all configuration options
--config-bare               bare bones configuration 
--solarize                  solarize the terminal
--test                      tester program
            
_EOF_
}

# Installation functions
function install_autojump() {
    # Install autojump
    if which autojump &>/dev/null; then
        echo "[${RED} FAIL ${NORMAL}] Autojump already installed"
    else
        cd shells/autojump
        ./install.sh
        cd ${CONFDIR}
        echo "[${GREEN} OKAY ${NORMAL}] Autojump installed"
    fi
}

# Configuration Functions
#Vim configuration
function config_vim() {
    if which vim &>/dev/null; then
        cd
        if [ -d .vim ]; then
            echo "[${RED} FAIL ${NORMAL}] Vim configuration failed. Delete ~/.vim and retry"
        else
            ln -s "${CONFDIR}/config/vim/vim" .vim
            ln -s "${CONFDIR}/config/vim/vimrc" .vimrc
        fi
        cd $CONFDIR
    else
        echo "[${RED} FAIL ${NORMAL}] Vim configuration failed. Install vim first"
    fi
}

# Git configuration
function config_git() {
    if which git &> /dev/null; then
        git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"""
        git config --global user.name "Srijan R Shetty"
        git config --global user.email "srijan.shetty@gmail.com"
        echo "[${GREEN} OKAY ${NORMAL}] Git configured."
    else
        echo "[${RED} FAIL ${NORMAL}] Git failed. Install git first"
    fi
}

#ZSH configuration
function config_zsh() {
    if which zsh &> /dev/null; then
        cd
        if [[ -d .zprezto ]]; then
            echo "[${RED} FAIL ${NORMAL}] Prezto failed. Delete ~/.zprezto and retry"
        else
            ln -s "${CONFDIR}/shells/zsh/zprezto" .zprezto

            setopt EXTENDED_GLOB
            for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
                ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
            done
            cd ${CONFDIR}
            echo "[${GREEN} OKAY ${NORMAL}] Prezto configured."
        fi
    fi
}

#Solarize the terminal
function config_solarize() {
    if [ -e ~/.dircolors ]; then
        echo "[${RED} FAIL ${NORMAL}] Solarize failed. Delete ~/.dircolors and retry"
    else
        cp shells/dircolors.ansi-light ~/.dircolors
        eval `dircolors ~/.dircolors`
        shells/solarize/solarize
        echo "[${GREEN} OKAY ${NORMAL}] Solarize configured"
    fi
}

#Synapse configuration
function config_synapse {
    if which synapse &> /dev/null; then
        cd ~/.config
        if [[ -e synapse ]]; then
            echo "[${RED} FAIL ${NORMAL}] Synapse failed. Delete ~/.config/synapse and retry"
        else
            echo "[${GREEN} OKAY ${NORMAL}] Synapse configured"
        fi
        cd $CONFDIR
    fi
}

#I haven't used it recently but still
function config_xmodmap {
    # Map caps lock to escape
    cd
    if [ -e .Xmodmap ]; then 
        echo "[${RED} FAIL ${NORMAL}] Remap failed. Delete ~/.xmodmap and retry"
    else
        ln -s ${CONFDIR}/config/Xmodmap .Xmodmap
        echo "[${GREEN} OKAY ${NORMAL}] Remap configured"
    fi
    cd ${CONFDIR}
}

#This is for xinitrc
function config_xinitrc {
    cd 
    if [ -e .xinitrc ]; then
        echo "[${RED} FAIL ${NORMAL}] Xinitrc Failed. Delete ~/.xinitrc and retry"
    else
        ln -s "${CONFDIR}/config/xinitrc" .xinitrc
        echo "[${GREEN} OKAY ${NORMAL}] Xinitrc configured"
    fi
}

#Configure xmonad
function config_xmonad {
    if which xmonad &> /dev/null; then
        cd
        if [ -d .xmonad ]; then
            echo "[${RED} FAIL ${NORMAL}] Xmonad failed. Delete ~/.xmonad and retry"
        else
            ln -s "${CONFDIR}/config/xmonad" .xmonad
            cd ${CONFDIR}
            xmonad --recompile
            echo "[${GREEN} OKAY ${NORMAL}] Xmonad configured"
        fi
    fi
}

#Configuration file for screen
function config_screen {
    cd 
    if [ -e .screenrc ]; then
        echo "[${RED} FAIL ${NORMAL}] Screen failed. Delete ~/.screenrc and retry"
    else
        ln -s "${CONFDIR}/config/screenrc" .screenrc
        cd ${CONFDIR}
        echo "[${GREEN} OKAY ${NORMAL}] Screen configured"
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
    config_solarize
    install_autojump
}

#Store the configuration directory for use by the functions
CONFDIR=${PWD}

#colored outputs
NORMAL=$(tput sgr0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)

# Here we process all the command line arguments passed to the bootstrapper
while [ -n "$1" ]; do
    case "$1" in 
        -x | --xmonad-config) config_xmonad;;

        -v | --vim-config) config_vim;;

        -g | --git-config) config_git;;

        -z | --zsh-config) config_zsh;;

        -s | --screen-config) config_screen;;
        
        -c | --config) config;;
        
        -a | --autojump) install_autojump;;

        -i | --xinitrc-config) config_xinitrc;;

        -y | --synapse-config) config_synapse;;

        -r | --remap-config) config_xmodmap;;
        
        -h | --help ) help_text;;

        --config-bare) config_bare;;
    
        --solarize) config_solarize;;

        --test) tester;;
    esac
    shift
done
