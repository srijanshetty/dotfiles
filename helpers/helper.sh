#!/bin/bash

# This indicates that helper has been sources
DOT_HELPER=1

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
       echo "${UNDERLINE_ON}$* ${UNDERLINE_OFF}" | tee -a "$LOGFILE"
}

function checkconf() {
    configfile_secured=/tmp/config.cfg
    # Check if the configfile exists
    if [ ! -f "$1" ]; then
        echo "[ ${YELLOW}WARN${NORMAL} ] Config file not found"
        exit 1
    fi

    # check if the file contains something we don't want
    if egrep -q -v '^#|^[^ ]*=[^;]*' "$1"; then
      export LOGFILE=/dev/null
      warn "Config file is unclean" >&2

      # filter the original to a new file
      egrep '^#|^[^ ]*=[^;&]*'  "$1" > "$configfile_secured"
      mv "$configfile_secured" "$1"
    fi

    # now source it, either the original or the filtered variant
    source "$1"
}

function log() {
    echo "[$(date)]: $*" &>> $LOGFILE
}

# Source required files
# HELPER_DIR="$(dirname "$0")"
# configfile="${HELPER_DIR}/helpers/config.cfg"
# checkconf "$configfile"
LOGFILE=/dev/null
