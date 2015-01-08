#!/bin/bash

# Source required files
HELPER_DIR="$(dirname "$0")"
[ -z "$DOT_HELPER" ] && source "${HELPER_DIR}/helper.sh"

# Function to add a ppa
function add-ppa() {
  grep -h "^deb.*$1" /etc/apt/sources.list.d/* &>> "$LOGFILE"
  if [ $? -ne 0 ]; then
    success "Adding ppa:$1"
    sudo add-apt-repository -y "ppa:$1" | tee -a "$LOGFILE"
    return 0
  fi

  warn "ppa:$1 already exists"
  return 1
}

# function to install something using apt-get
function installer() {
    APPLICATION_NAME=""

    while [ -n "$1" ]; do
        case "$1" in
            -n )
                shift
                APPLICATION_NAME="$1"
                if hash "$1" &>> "$LOGFILE"; then
                    warn "$1 is already installed"
                    return 0
                fi
                ;;

            -p )
                if [ -z "$APPLICATION_NAME" ]; then
                    fail "No Application name provided in installer"
                    return 1
                fi

                shift
                if sudo apt-get install -y "$1" &>> "$LOGFILE"; then
                    success "${APPLICATION_NAME} installed"
                    return 0
                else
                    fail "${APPLICATION_NAME} installation failed"
                    return 1
                fi
                ;;

            * )
                if hash "$1" &>> "$LOGFILE"; then
                    warn "$1 is already installed"
                else
                    if sudo apt-get install --force-yes -y "$1" &>> "$LOGFILE"; then
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

# a function to install something using pip
function pip-install() {
    if hash pip &> /dev/null; then
        if hash "$1" &> /dev/null; then
            warn "$1 is already installed"
            return 0
        else
            if sudo pip install "$1" &>> "$LOGFILE"; then
                success "$1 installed"
                return 0
            else
                fail "$1 installation"
                return 1
            fi
        fi
    else
        fail "Pip not installed. Install pip and then try"
        return 1
    fi
}

# a function to install something using npm
function npm-install() {
    if hash npm &> /dev/null; then
        if hash "$1" &> "$LOGFILE"; then
            warn "$1 is already installed"
            return 0
        else
            if npm install -g "$1" &>> "$LOGFILE"; then
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

# Install RVM
function install-rvm() {
    if hash rvm &>> "$LOGFILE"; then
        warn "RVM already installed"
        return 0
    else
        if curl -sSL https://get.rvm.io &>> "$LOGFILE" | bash -s stable --ruby &>> "$LOGFILE"; then
            success "RVM Installed"
            return 0
        else
            fail "RVM Installation failed"
            return 1
        fi
    fi
}

# To indicate that this script has been included
DOT_INSTALL=1
