#!/bin/zsh

#Help text
function help_text() {
cat <<- _EOF_

USAGE: bootstrap.sh <arguments>

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
        echo "[${RED} FAIL ${NORMAL}] Autojump is already installed"
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
            ERR=1
        else
            ln -s "${CONFDIR}/config/vim/vim" .vim
            ln -s "${CONFDIR}/config/vim/vimrc" .vimrc
        fi
        cd $CONFDIR
    else
        echo "[${RED} FAIL ${NORMAL}] Vim configuration failed. Install vim first"
        ERR=2
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
        echo "[${RED} FAIL ${NORMAL}] Git configuration failed. Install git first"
        ERR=2
    fi
}

#ZSH configuration
function config_zsh() {
    if which zsh &> /dev/null; then
        cd
        if [[ -d .zprezto ]]; then
            echo "[${RED} FAIL ${NORMAL}] Prezto configuration failed. Delete ~/.zprezto and retry"
            ERR=1
        else
            ln -s "${CONFDIR}/shells/zsh/zprezto" .zprezto

            setopt EXTENDED_GLOB
            for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
                ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
            done
            cd ${CONFDIR}
            echo "[${GREEN} OKAY ${NORMAL}] Prezto configured."
        fi
    else
        echo "[${RED} FAIL ${NORMAL}] Zsh configuration failed. Install zsh first"
        ERR=2
    fi
}

#Solarize the terminal
function config_solarize() {
    if [ -e ~/.dircolors ]; then
        echo "[${RED} FAIL ${NORMAL}] Solarize configuration failed. Delete ~/.dircolors and retry"
        ERR=1
    else
        cp shells/dircolors.ansi-light ~/.dircolors
        eval `dircolors ~/.dircolors`
        shells/solarize/solarize
        echo "[${GREEN} OKAY ${NORMAL}] Solarize configured"
    fi
}

#Synapse configuration
function config_synapse() {
    if which synapse &> /dev/null; then
        if [ -e ~/.config/synapse/config.json ]; then
            echo "[${RED} FAIL ${NORMAL}] Synapse configuration failed. Delete ~/.config/synapse and retry"
            ERR=1
        else
            cd ~/.config/synapse
            ln -s "${CONFDIR}/config/synapse/config.json" config.json
            echo "[${GREEN} OKAY ${NORMAL}] Synapse configured"
            cd $CONFDIR
        fi
    else
        echo "[${RED} FAIL ${NORMAL}] Synapse configuration failed. Install synapse first"
        ERR=2
    fi
}

#I haven't used it recently but still
function config_xmodmap() {
    # Map caps lock to escape
    cd
    if [ -e .Xmodmap ]; then 
        echo "[${RED} FAIL ${NORMAL}] Remap configuration failed. Delete ~/.xmodmap and retry"
        ERR=1
    else
        ln -s ${CONFDIR}/config/Xmodmap .Xmodmap
        echo "[${GREEN} OKAY ${NORMAL}] Remap configured"
    fi
    cd ${CONFDIR}
}

#This is for xinitrc
function config_xinitrc() {
    cd 
    if [ -e .xinitrc ]; then
        echo "[${RED} FAIL ${NORMAL}] Xinitrc configuration Failed. Delete ~/.xinitrc and retry"
        ERR=1
    else
        ln -s "${CONFDIR}/config/xinitrc" .xinitrc
        echo "[${GREEN} OKAY ${NORMAL}] Xinitrc configured"
    fi
}

#Configure xmonad
function config_xmonad() {
    if which xmonad &> /dev/null; then
        cd
        if [ -d .xmonad ]; then
            echo "[${RED} FAIL ${NORMAL}] Xmonad configuration failed. Delete ~/.xmonad and retry"
            ERR=1
        else
            ln -s "${CONFDIR}/config/xmonad" .xmonad
            cd ${CONFDIR}
            xmonad --recompile
            echo "[${GREEN} OKAY ${NORMAL}] Xmonad configured"
        fi
    else
        echo "[${RED} FAIL ${NORMAL}] xmonad configuration failed. Install xmonad first"
        ERR=2
    fi
}

#Configuration file for screen
function config_screen() {
    if which screen &> /dev/null; then
        cd 
        if [ -e .screenrc ]; then
            echo "[${RED} FAIL ${NORMAL}] Screen configuration failed. Delete ~/.screenrc and retry"
            ERR=1
        else
            ln -s "${CONFDIR}/config/screenrc" .screenrc
            cd ${CONFDIR}
            echo "[${GREEN} OKAY ${NORMAL}] Screen configured"
        fi
    else
        echo "[${RED} FAIL ${NORMAL}] screen configuration failed. Install screen first"
        ERR=2
    fi
}

#Autoinstallers
#Install everything
function config() {
    config_bare
    config_xmonad
    config_xinitrc
    config_xmodmap
    config_synapse
}

#Install only essential stuff
function config_bare() {
    config_git
    config_zsh
    config_vim
    config_screen
    install_autojump
    config_solarize
}

#Store the configuration directory for use by the functions
CONFDIR=${PWD}

# Debug messages 
NORMAL=$(tput sgr0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)

# flag for errors
ERR=0

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

# return the exit status
exit $ERR
