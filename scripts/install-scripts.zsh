#!/bin/zsh

source ./helper.sh

function inRepo {
    for file in /etc/apt/sources.list.d/*.list; do
        grep "$1" $file
    done
}

# function to install something using apt-get
function installer() {
    if hash apt-get &> /dev/null; then
        installing_software="apt-get"
    elif hash pact &> /dev/null; then
        installing_software="pact"
    else
        fail "Cannot Install"
    fi

    APPLICATION_NAME=""
    while [ -n "$1" ]; do
        case "$1" in
            -n )
                shift
                APPLICATION_NAME=$1
                if hash $1 &> /dev/null; then
                    warn "$1 is already installed"
                    return 0
                fi
                ;;

            -p )
                shift
                if sudo ${installing_software} install -y $1 &>/dev/null; then
                    success "${APPLICATION_NAME} installed"
                    return 0
                else
                    fail "${APPLICATION_NAME} installation failed"
                    return 1
                fi
                ;;

            * )
                if hash $1 &> /dev/null; then
                    warn "$1 is already installed"
                else
                    if sudo ${installing_software} install -y $1 &>/dev/null; then
                        success "$1 installed"
                        return 0
                    else
                        fail "$1 installation"
                        return 1
                    fi
                fi
                ;;
        esac
        shift
    done

}

# a function to install something using npm
function npm_install() {
    if hash npm &> /dev/null; then
        if hash $1 &> /dev/null; then
            warn "$1 is already installed"
            return 0
        else
            if npm install -g $1 &>/dev/null; then
                success "$1 installed"
                return 0
            else
                fail "$1 installation"
                return 1
            fi
        fi
    else
        fail "NPM not installed. Install npm and then try"
        return 1
    fi
}

# Function to add a ppa
function add_ppa() {
  grep -h "^deb.*$1" /etc/apt/sources.list.d/* &> /dev/null
  if [ $? -ne 0 ]; then
    success "Adding ppa:$1"
    sudo add-apt-repository -y ppa:$1
  fi

  warn "ppa:$1 already exists"
  return 0
}

# Installation functions
function install_autojump() {
    highlight "\nInstalling autojump"

    if hash autojump &> /dev/null; then
        warn "Autojump is already installed"
        return 0
    fi

    if cd shells/autojump && ./install.py; then
        success "Autojump installed"
        cd ${CONFDIR}
        return 0
    else
        fail "Autojump failed"
        return 1
    fi
}

# Install NVM
function install_nvm() {
    highlight "\nInstalling NVM"

    export NVM_DIR=~/.nvm
    if hash nvm &> /dev/null; then
        warn "NVM is already installed"
        return 0
    fi

    # Get the install script
    if wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.12.0/install.sh | bash; then
        success "NVM installed"
        return 0
    else
        fail "NVM not installed"
        return 1
    fi
}

# Install ack
function install_ack() {
    if hash ack &> /dev/null; then
        warn "ack already installed"
        return 0
    fi

    # Create the directory
    if [ ! -d ${HOME}/Documents/local/bin ]; then
        mkdir -p ${HOME}/Documents/local/bin
    fi

    # Dowlonad the ack script
    if wget -O "${HOME}/Documents/local/bin/ack" http://beyondgrep.com/ack-2.12-single-file; then
        chmod u+x "${HOME}/Documents/local/bin/ack"
        success "ack installed"
        return 0
    else
        fail "ack installation"
        return 1
    fi
}

function install_tmux_networkspeed() {
    RETURN_VALUE=0

    if [ ! -f ~/Documents/GitHub ]; then
        mkdir -p ~/Documents/GitHub
    fi

    cd ~/Documents/GitHub

    # Copy tmux-networkspeed
    if [ ! -d tmux-networkspeed ]; then
        git clone https://github.com/srijanshetty/tmux-networkspeed.git
        if [ $? -eq 0 ]; then
            success "tmux-networkspeed installed"
        else
            fail "tmux-networkspeed installation failed"
            RETURN_VALUE=1
        fi
    else
        warn "tmux-networkspeed already exists"
    fi

    cd -
    return RETURN_VALUE
}

function install_sysadmin() {
    RETURN_VALUE=0

    if [ ! -f ~/Documents/GitHub ]; then
        mkdir -p ~/Documents/GitHub
    fi

    cd ~/Documents/GitHub

    # Copy tmux-networkspeed
    if [ ! -d sysadmin ]; then
        git clone https://github.com/skx/sysadmin-util.git sysadmin
        if [ $? -eq 0 ]; then
            success "sysadmin tools installed"
        else
            fail "sysadmin tools installation failed"
            RETURN_VALUE=1
        fi
    else
        warn "sysadmin tools already exists"
    fi

    cd -
    return RETURN_VALUE
}
