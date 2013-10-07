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
        fail "Autojump is already installed"
    else
        cd shells/autojump
        ./install.sh
        cd ${CONFDIR}
        success "Autojump installed"
    fi
}

# Configuration Functions
#Vim configuration
function config_vim() {
    if which vim &>/dev/null; then
        cd
        if [ -d .vim ]; then
            fail "Vim configuration failed. Delete ~/.vim and retry"
            ERR=1
        else
            ln -s "${CONFDIR}/config/vim/vim" .vim
            ln -s "${CONFDIR}/config/vim/vimrc" .vimrc
        fi
        cd $CONFDIR
    else
        fail "Vim configuration failed. Install vim first"
        ERR=2
    fi
}

# Git configuration
function config_git() {
    if which git &> /dev/null; then
        git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"""
        git config --global user.name "Srijan R Shetty"
        git config --global user.email "srijan.shetty@gmail.com"
        success "Git configured."
    else
        fail "Git configuration failed. Install git first"
        ERR=2
    fi
}

#ZSH configuration
function config_zsh() {
    if which zsh &> /dev/null; then
        cd
        if [[ -d .zprezto ]]; then
            fail "Prezto configuration failed. Delete ~/.zprezto and retry"
            ERR=1
        else
            ln -s "${CONFDIR}/shells/zsh/zprezto" .zprezto

            setopt EXTENDED_GLOB
            for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
                ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
            done
            cd ${CONFDIR}
            success "Prezto configured."
        fi
    else
        fail "Zsh configuration failed. Install zsh first"
        ERR=2
    fi
}

#Solarize the terminal
function config_solarize() {
    if [ -e ~/.dircolors-light ]; then
        fail "Solarize configuration failed. Delete ~/.dircolors and retry"
        ERR=1
    else
        cp shells/dircolors.ansi-light ~/.dircolors-light
        cp shells/dircolors.ansi-dark ~/.dircolors-dark
        eval `dircolors ~/.dircolors-light`
        shells/solarize/solarize
        success "Solarize configured"
    fi
}

#Synapse configuration
function config_synapse() {
    if which synapse &> /dev/null; then
        if [ -e ~/.config/synapse/config.json ]; then
            fail "Synapse configuration failed. Delete ~/.config/synapse and retry"
            ERR=1
        else
            cd ~/.config/synapse
            ln -s "${CONFDIR}/config/synapse/config.json" config.json
            success "Synapse configured"
            cd $CONFDIR
        fi
    else
        fail "Synapse configuration failed. Install synapse first"
        ERR=2
    fi
}

#I haven't used it recently but still
function config_xmodmap() {
    # Map caps lock to escape
    cd
    if [ -e .Xmodmap ]; then 
        fail "Remap configuration failed. Delete ~/.xmodmap and retry"
        ERR=1
    else
        ln -s ${CONFDIR}/config/Xmodmap .Xmodmap
        success "Remap configured"
    fi
    cd ${CONFDIR}
}

#This is for xinitrc
function config_xinitrc() {
    cd 
    if [ -e .xinitrc ]; then
        fail "Xinitrc configuration Failed. Delete ~/.xinitrc and retry"
        ERR=1
    else
        ln -s "${CONFDIR}/config/xinitrc" .xinitrc
        success "Xinitrc configured"
    fi
}

#Configure xmonad
function config_xmonad() {
    if which xmonad &> /dev/null; then
        cd
        if [ -d .xmonad ]; then
            fail "Xmonad configuration failed. Delete ~/.xmonad and retry"
            ERR=1
        else
            ln -s "${CONFDIR}/config/xmonad" .xmonad
            cd ${CONFDIR}
            xmonad --recompile
            success "Xmonad configured"
        fi
    else
        fail "xmonad configuration failed. Install xmonad first"
        ERR=2
    fi
}

#Configuration file for screen
function config_screen() {
    if which screen &> /dev/null; then
        cd 
        if [ -e .screenrc ]; then
            fail "Screen configuration failed. Delete ~/.screenrc and retry"
            ERR=1
        else
            ln -s "${CONFDIR}/config/screenrc" .screenrc
            cd ${CONFDIR}
            success "Screen configured"
        fi
    else
        fail "screen configuration failed. Install screen first"
        ERR=2
    fi
}

#Configure sublime text
function config_sublime() {
    if which subl &> /dev/null; then
        cd ~/.config
        if [ -d sublime-text3 ]; then
            fail "Sublime text configuration failed. Remove ~/.config/sublime-text3 and retry."
            ERR=1
        else
            ln -s "${CONFDIR}/config/sublime-text3" sublime-text3 
            cd ${CONFDIR}
            success "Sublime Text configured"
        fi
    else
        fail "Sublime text configuration failed. Install sublime text and then retry"
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

#for helper function
source helper.sh

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
