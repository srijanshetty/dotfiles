#!/bin/zsh

# Source required files
DOT_DIR_NAME="$(dirname "$0")"
[ -z $DOT_HELPER ] && source "${DOT_DIR_NAME}/helper.sh"

function run() {
    if pgrep $1 &> /dev/null; then
        warn "$1 is running"
    else
        if $2 &> /dev/null &; then
            success "$1 is now running"
        else
            fail "$1 running failed"
        fi
    fi

}

function processkill() {
    if pgrep $1 &> /dev/null; then
        pkill $1 && success "$1 killed"
    else
        warn "$1 is not running"
    fi
}

case $1 in
    kill|stop)
        processkill 'xSwipe.pl'
        processkill 'btsync'
        processkill 'firewall-auth'
        ;;
    *)
        run 'xSwipe.pl' '/home/srijan/Documents/GitHub/xSwipe/xSwipe.pl'
        run 'btsync' 'btsync'
        run 'firewall-auth' '/home/srijan/Documents/firewall-auth'
        ;;
esac
