#!/bin/zsh

# Source required files
HELPER_DIR="$(dirname "$0")"
[ -z $DOT_HELPER ] && source "${HELPER_DIR}/helper.sh"
[ -z $DOT_CONFIGURE ] && source "${HELPER_DIR}/configure.zsh"

# Install PIP
function install_pip() {
    highlight "\nInstalling easy_setup"

    wget http://peak.telecommunity.com/dist/ez_setup.py &>> $LOGFILE && python ez_setup.py &>> $LOGFILE && rm ez_setup.py &>> $LOGFILE

    if [ $? -eq 0 ]; then
        success "easy_setup installed"
    else
        fail "easy_setup installation failed"
        return 1
    fi

    highlight "\nInstalling pip"
    if easy_install pip &>> $LOGFILE; then
        success "pip installed"
    else
        fail "pip installation failed"
    fi
}

# function to install something using apt-get
function installer() {
    APPLICATION_NAME=""

    while [ -n "$1" ]; do
        case "$1" in
            -n )
                shift
                APPLICATION_NAME="$1"
                if hash $1 &>> $LOGFILE; then
                    warn "$1 is already installed"
                    return 0
                fi
                ;;

            -p )
                if [ -z $APPLICATION_NAME ]; then
                    fail "No Application name provided in installer"
                    return 1
                fi

                shift
                if sudo apt-get install -y $1 &>> $LOGFILE; then
                    success "${APPLICATION_NAME} installed"
                    return 0
                else
                    fail "${APPLICATION_NAME} installation failed"
                    return 1
                fi
                ;;

            * )
                if hash $1 &>> $LOGFILE; then
                    warn "$1 is already installed"
                else
                    if sudo apt-get install --force-yes -y $1 &>> $LOGFILE; then
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
function npm-install() {
    if hash npm &> /dev/null; then
        if hash $1 &> /dev/null; then
            warn "$1 is already installed"
            return 0
        else
            if npm install -g $1 &>> $LOGFILE; then
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
function add-ppa() {
  grep -h "^deb.*$1" /etc/apt/sources.list.d/* &>> $LOGFILE
  if [ $? -ne 0 ]; then
    success "Adding ppa:$1"
    sudo add-apt-repository -y ppa:$1 | tee -a $LOGFILE
    return 0
  fi

  warn "ppa:$1 already exists"
  return 1
}

# Install RVM
function install_rvm() {
    highlight "\nInstalling RVM"

    if hash rvm &>> $LOGFILE; then
        warn "RVM already installed"
        return 0
    else
        if curl -sSL https://get.rvm.io &>> $LOGFILE | bash -s stable --ruby &>> $LOGFILE; then
            success "RVM Installed"
            return 0
        else
            fail "RVM Installation failed"
            return 1
        fi
    fi
}

# install mr
function install_mr() {
    RETURN_VALUE=0

    if [ ! -d $GITHUB_DIR ]; then
        mkdir -p $GITHUB_DIR
    fi

    cd $GITHUB_DIR

    # Copy mr
    if [ ! -d mr ]; then
        if git clone https://github.com/joeyh/mr.git myrepos &>> $LOGFILE; then
            success "mr installed"
        else
            fail "mr installation failed"
            RETURN_VALUE=1
        fi
    else
        warn "mr already exists"
    fi

    # configure mr
    configure "MR" "${GITHUB_DIR}/myrepos/mr" "${LOCAL_BIN}/mr" || RETURN_VALUE=1

    cd -
    return RETURN_VALUE
}

# To indicate that this script has been included
DOT_INSTALL=1
