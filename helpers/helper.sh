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
        echo "[${RED} FAIL ${NORMAL}] $*" | tee -a "$LOGFILE"
}

function warn() {
        echo "[ ${YELLOW}WARN${NORMAL} ] $*" | tee -a "$LOGFILE"
}

function success() {
        echo "[${GREEN} OKAY ${NORMAL}] $*" | tee -a "$LOGFILE"
}

function highlight() {
       echo "${UNDERLINE_ON}$*${UNDERLINE_OFF}" | tee -a "$LOGFILE"
}

# This indicates that helper has been sources
DOT_HELPER=1
