#!/bin/zsh

# Source required files
DIR="$(dirname "$0")"
[ -z $DOT_CONF ] && source "${DIR}/conf.sh"

# Debug messages
NORMAL=$(tput sgr0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput smso; tput setaf 3)
UNDERLINE_ON=$(tput smul)
UNDERLINE_OFF=$(tput rmul)

# function to output messages on the console
function fail() {
        echo "[${RED} FAIL ${NORMAL}] $*" | tee $LOGFILE
}

function warn() {
        echo "[ ${YELLOW}WARN${NORMAL} ] $*" | tee $LOGFILE
}

function success() {
        echo "[${GREEN} OKAY ${NORMAL}] $*" | tee $LOGFILE
}

function highlight() {
        echo "${UNDERLINE_ON}$*${UNDERLINE_OFF}" | tee $LOGFILE
}

# This indicates that helper has been sources
DOT_HELPER=1
