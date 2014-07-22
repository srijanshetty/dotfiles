#!/bin/zsh

# Debug messages
NORMAL=$(tput sgr0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput smso; tput setaf 3)
UNDERLINE_ON=$(tput smul)
UNDERLINE_OFF=$(tput rmul)

# function to output messages on the console
function fail() {
        echo "[${RED} FAIL ${NORMAL}] $*"
}

function warn() {
        echo "[ ${YELLOW}WARN${NORMAL} ] $*"
}

function success() {
        echo "[${GREEN} OKAY ${NORMAL}] $*"
}

function highlight() {
        echo "${UNDERLINE_ON}$*${UNDERLINE_OFF}"
}

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

    while [ -n "$1" ]; do
        case "$1" in
            -n )
                shift
                if hash $1 &> /dev/null; then
                    warn "$1 is already installed"
                    return
                fi
                ;;

            -p )
                shift
                if sudo ${installing_software} install -y $1 &>/dev/null; then
                    success "$1 installed"
                else
                    fail "$1 installation"
                    ERR=1
                fi
                ;;

            * )
                if hash $1 &> /dev/null; then
                    warn "$1 is already installed"
                else
                    if sudo ${installing_software} install -y $1 &>/dev/null; then
                        success "$1 installed"
                    else
                        fail "$1 installation"
                        ERR=1
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
        else
            if npm install -g $1 &>/dev/null; then
                success "$1 installed"
            else
                fail "$1 installation"
                ERR=1
            fi
        fi
    else
        fail "NPM not installed. Install npm and then try"
    fi
}
