#!/bin/zsh

# This indicates that the ocnfigure has been sources
DOT_CONFIGURE=1

# Source required files
HELPER_DIR="$(dirname "$0")"
[ -z $DOT_HELPER ] && source "${HELPER_DIR}/helper.sh"

# configuration function
function configure() {
    highlight "\nConfiguring $1"

    if ln -s "$2" "$3" &>> $LOGFILE; then
        success "$1 : created symlinks for $2 at $3"
        return 0
    else
        fail "$1 : failed to create symlinks at $3"
        return 1
    fi
}
