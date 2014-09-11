#!/bin/zsh

# Source required files
DOT_DIR_NAME="$(dirname "$0")"
[ -z $DOT_HELPER ] && source "${DOT_DIR_NAME}/helper.sh"

if pgrep xSwipe.pl &> /dev/null; then
    warn "xSwipe is running"
else
    /home/srijan/Documents/GitHub/xSwipe/xSwipe.pl &
    success "xSwipe is now running"
fi

if pgrep btsync &> /dev/null; then
    warn "Btsync is running"
else
    btsync &> /dev/null
    success "btsync is now running"
fi

# sudo service auth start
