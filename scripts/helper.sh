#!/bin/zsh

# Source required files
DOT_DIR_NAME="$(dirname "$0")"
[ -z $DOT_CONF ] && source "${DOT_DIR_NAME}/conf.sh"

# Debug messages
NORMAL=$(tput sgr0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput smso; tput setaf 3)
UNDERLINE_ON=$(tput smul)
UNDERLINE_OFF=$(tput rmul)

# function to output messages on the console
function fail() {
        echo "[${RED} FAIL ${NORMAL}] $*" | tee "$LOGFILE"
}

function warn() {
        echo "[ ${YELLOW}WARN${NORMAL} ] $*" | tee "$LOGFILE"
}

function success() {
        echo "[${GREEN} OKAY ${NORMAL}] $*" | tee "$LOGFILE"
}

function highlight() {
       echo "${UNDERLINE_ON}$*${UNDERLINE_OFF}" | tee "$LOGFILE"
}

function configure() {
    highlight "\nConfiguring $1"

    if hash vim &> "$LOGFILE"; then
        if [ -d $2 ]; then
            fail "$1 : delete $2 and retry"
            return 1
        else
            if ln -s "$3" "$2" ; then
                success "$1 : configured"
                return 0
            else
                fail "$1 : failed to create symlinks"
                return 1
            fi
        fi
    else
        fail "$1: install $1"
        return 1
    fi
}

# This indicates that helper has been sources
DOT_HELPER=1
