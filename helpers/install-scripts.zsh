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
    while [ -n "$1" ]; do
        case "$1" in
            -n )
                shift
                APPLICATION_NAME="$1"
                if hash $1 &> $LOGFILE; then
                    warn "$1 is already installed"
                    return 0
                fi
                ;;

            -p )
                shift
                if sudo apt-get install -y $1 &> $LOGFILE; then
                    success "${APPLICATION_NAME} installed"
                    return 0
                else
                    fail "${APPLICATION_NAME} installation failed"
                    return 1
                fi
                ;;

            * )
                if hash $1 &> $LOGFILE; then
                    warn "$1 is already installed"
                else
                    if sudo apt-get install --force-yes -y $1 &> $LOGFILE; then
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
            if npm install -g $1 &> $LOGFILE; then
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
  grep -h "^deb.*$1" /etc/apt/sources.list.d/* &> $LOGFILE
  if [ $? -ne 0 ]; then
    success "Adding ppa:$1"
    sudo add-apt-repository -y ppa:$1 | tee $LOGFILE
    return 0
  fi

  warn "ppa:$1 already exists"
  return 1
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

# Install RVM
function install_rvm() {
    highlight "\nInstalling RVM"

    if hash rvm &> $LOGFILE; then
        warn "RVM already installed"
        return 0
    else
        if curl -sSL https://get.rvm.io &> $LOGFILE | bash -s stable --ruby &> $LOGFILE; then
            success "RVM Installed"
            return 0
        else
            fail "RVM Installation failed"
            return 1
        fi
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
    if wget -O "${HOME}/Documents/local/bin/ack" http://beyondgrep.com/ack-2.12-single-file &> $LOGFILE; then
        chmod u+x "${HOME}/Documents/local/bin/ack"
        success "ack installed"
        return 0
    else
        fail "ack installation"
        return 1
    fi
}

function install_mr() {
    RETURN_VALUE=0

    if [ ! -f $GITHUB_DIR ]; then
        mkdir -p $GITHUB_DIR
    fi

    cd $GITHUB_DIR

    # Copy tmux-networkspeed
    if [ ! -d tmux-networkspeed ]; then
        if git clone https://github.com/joeyh/mr.git &> $LOGFILE; then
            success "mr installed"
        else
            fail "mr installation failed"
            RETURN_VALUE=1
        fi
    else
        warn "mr already exists"
    fi

    cd -
    return RETURN_VALUE
}

# To indicate that this script has been included
DOT_INSTALL_SCRIPTS=1
