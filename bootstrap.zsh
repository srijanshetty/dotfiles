#!/bin/zsh

#Help text
function help_text() {
cat <<- _EOH_

USAGE: bootstrap.sh <arguments>

Available commands:

    -v | --vim-config           configure only vim
    -g | --git-config           configure git
    -z | --zsh-config           configure zsh using Prezto
    -t | --tmux-config          configure tmux
    -n | --node-config          configure node
    -m | --music-config         configure beets
    -w | --write-config         configure writing tools
    -x | --xmonad-config        configure only xmonad
    -i | --xinitrc-config       configure xinitrc
    -y | --synapse-config       configure synapse
    -r | --remap-config         configure remap of keys
    -a | --autojump             Install autojump
    -c | --config               apply all configuration options
    --config-ssh                configure ssh
    --config-sublime            configure sumblime text
    --config-bare               bare bones configuration
    --solarize                  solarize the terminal
    --test                      tester program
_EOH_
}

# Configuration Functions
#Vim configuration
function config_vim() {
    highlight "\nConfiguring Vim"
    if hash vim &> /dev/null; then
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
    highlight "\nConfiguring git"
    if hash git &> /dev/null; then
        cd
        # Configure git
        if [ -e .gitconfig ]; then
            fail "Git configuration exists. Delete ~./gitconfig and retry"
        else
            ln -s "${CONFDIR}/config/git/gitconfig" .gitconfig
            success "Git configured."
        fi

        # Configure global gitignore
        if [ -e .gitignore_global ]; then
            fail "Git ignore exists. Delete ~./gitignore_global and retry"
        else
            ln -s "${CONFDIR}/config/git/gitignore_global" .gitignore_global
            success "Global gitignore configured"
        fi
    else
        fail "Git configuration failed. Install git first"
        ERR=2
    fi
}

#ZSH configuration
function config_zsh() {
    highlight "\nConfiguring zsh"
    if hash zsh &> /dev/null; then
        cd
        if [[ -d .zprezto ]]; then
            fail "Prezto configuration failed. Delete ~/.zprezto and retry"
            ERR=1
        else
            # change default shell to zsh
            if [ -n $ZSH_NAME ]; then
                warn "The current shell is zsh"
            else
                chsh -s /bin/zsh
            fi

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

#Configuration file for tmux
function config_tmux() {
    highlight "\nConfiguring tmux"
    if hash tmux; then
        cd
        if [ -e .tmux.conf ]; then
            fail "tmux configuration failed. Delete ~/.tmux.conf and retry"
            ERR=1
        else
            ln -s "${CONFDIR}/config/tmux.conf" .tmux.conf
            cd ${CONFDIR}
            success "tmux configured"
        fi
    else
        fail "tmux configuration failed. Install tmux first"
        ERR=2
    fi
}

# Configure Node
function config_node() {
    nvm install 10.28
}

# Configure music
function config_music() {
    highlight "\nConfiguring Beets"
    if hash beet; then
        cd
        if [ -d .config/beets ]; then
            fail "Beets configuration failed. Delete ~/.config/beets and retry"
            ERR=1
        else
            ln -s "${CONFDIR}/config/beets" .config/beets
            cd ${CONFDIR}
            success "Beets configured"
        fi
    else
        fail "beets configuration failed. Install beet first"
        ERR=2
    fi
}

#configure writing tools
function config_write() {
    highlight "Configuring LaTeX"
    if hash pdflatex; then
        cd
        if [ -d texmf ]; then
            fail "Texmf already exists. Delete ~/texmf and retry"
            ERR=1
        else
            ln -s "${CONFDIR}/config/texmf" texmf
            cd ${CONFDIR}
            success "LaTeX configured"
        fi
    else
        fail "LaTeX configuration failed. First Install latex"
        ERR=2
    fi
}

#Configure xmonad
function config_xmonad() {
    highlight "\nConfiguring xmonad"
    if hash xmonad; then
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

#Solarize the terminal
function config_solarize() {
    highlight "\nConfiguring the color scheme"
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
    highlight "\nConfiguring synapse"
    if hash synapse &> /dev/null; then
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
function config_remap() {
    highlight "\nConfiguring xmodmap"

    # Map caps lock to escape
    if dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:escape']"; then
        success "Remap successful"
    else
        fail "Remap failed"
        ERR=1
    fi
}

#This is for xinitrc
function config_xinitrc() {
    highlight "\nConfiguring xinitrc"
    cd
    if [ -e .xinitrc ]; then
        fail "Xinitrc configuration Failed. Delete ~/.xinitrc and retry"
        ERR=1
    else
        ln -s "${CONFDIR}/config/system/xinitrc" .xinitrc
        success "Xinitrc configured"
    fi
}

# Configure sublime text
function config_sublime() {
    highlight "\nConfiguring sublime text"
    if hash subl; then
        cd ~/.config
        if [ -d sublime-text-3 ]; then
            fail "Sublime text configuration failed. Remove ~/.config/sublime-text3 and retry."
            ERR=1
        else
            ln -s "${CONFDIR}/config/sublime-text3" sublime-text-3
            cd ${CONFDIR}
            success "Sublime Text configured"
        fi
    else
        fail "Sublime text configuration failed. Install sublime text and then retry"
        ERR=2
    fi
}

# configure ssh
function config_ssh() {
    highlight "\nConfiguring ssh"
    cd ~/.ssh/
    if [ -f config ]; then
        fail "SSH configuration failed. Remove ~/ssh/config and retry."
        ERR=1
    else
        ln -s "${CONFDIR}/config/system/sshconfig" config
        cd ${CONFDIR}
        success "SSH configured"
    fi
}

# Autoinstallers
# Install only essential stuff
function config_bare() {
    config_git
    config_zsh
    config_vim
    config_ssh
    config_tmux
}

# Install everything
function config() {
    config_bare
    config_xmodmap
    config_xinitrc
    config_solarize
    config_xmonad
    config_synapse
    config_sublime
    config_node
}

# Store the configuration directory for use by the functions
CONFDIR=${PWD}

# for helper function
source scripts/helper.sh

# flag for errors
ERR=0

# Here we process all the command line arguments passed to the bootstrapper
while [ -n "$1" ]; do
    case "$1" in
        -x | --xmonad-config)
            config_xmonad;;

        -v | --vim-config)
            config_vim;;

        -g | --git-config)
            config_git;;

        -z | --zsh-config)
            config_zsh;;

        -t | --tmux-config)
            config_tmux;;

        -n | --node-config)
            config_node;;

        -m | --music-config)
            config_music;;

        -w | --write-config)
            config_write;;

        -c | --config)
            config;;

        -i | --xinitrc-config)
            config_xinitrc;;

        -y | --synapse-config)
            config_synapse;;

        -r | --remap-config)
            config_remap;;

        -h | --help )
            help_text;;

        --config-ssh)
            config_ssh;;

        --config-sublime)
            config_sublime;;

        --config-bare)
            config_bare;;

        --solarize)
            config_solarize;;

        --test)
            tester;;
    esac
    shift
done

# return the exit status
exit $ERR
