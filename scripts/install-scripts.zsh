#!/bin/zsh

# Source required files
DOT_DIR_NAME="$(dirname "$0")"
[ -z $DOT_CONF ] && source "${DOT_DIR_NAME}/conf.sh"
[ -z $DOT_HELPER ] && source "${DOT_DIR_NAME}/helper.sh"

# Install PIP
function install_pip() {
    highlight "\nInstalling easy_setup"

    wget http://peak.telecommunity.com/dist/ez_setup.py &> $LOGFILE && python ez_setup.py &> $LOGFILE && rm ez_setup.py &> $LOGFILE

    if [ $? -eq 0 ]; then
        success "easy_setup installed"
    else
        fail "easy_setup installation failed"
        return 1
    fi

    highlight "\nInstalling pip"
    if easy_install pip &> $LOGFILE; then
        success "pip installed"
    else
        fail "pip installation failed"
    fi
}

# To check whether something is inRepo
function inRepo {
    for file in /etc/apt/sources.list.d/*.list; do
        grep "$1" $file
    done
}

# function to install something using apt-get
function installer() {
    APPLICATION_NAME=""
    while [ -z "$1" ]; do
        case "$1" in
            -n )
                shift
                APPLICATION_NAME="$1"
                if hash $1 &> /dev/null; then
                    warn "$1 is already installed"
                    return 0
                fi
                ;;

            -p )
                shift
                if sudo apt-get install -y $1 &>/dev/null; then
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
                    if sudo apt-get install -y $1 &>/dev/null; then
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
    return 0
  fi

  warn "ppa:$1 already exists"
  return 1
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
        git clone https://github.com/srijanshetty/tmux-networkspeed.git &> $LOGFILE
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
        git clone https://github.com/skx/sysadmin-util.git sysadmin &> $LOGFILE
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

# To indicate that this script has been included
DOT_INSTALL_SCRIPTS=1
