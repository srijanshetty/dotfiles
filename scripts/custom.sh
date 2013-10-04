#!/bin/bash

#help text
function help_text(){
cat << _EOF_
USAGE: custom.sh <arguments>
VERSION: 0.0.2

Available Commands:

-a | --ack              Install Ack

_EOF_

}

#Ack installer
function install_ack {
    if [ -d ${HOME}/Documents/local/bin ]; then
        echo "The home directory already exists"
    else
        mkdir -p ${HOME}/local/bin
    fi
    wget -O "${HOME}/Documents/local/bin/ack" http://beyondgrep.com/ack-2.08-single-file 
    chmod u+x "${HOME}/Documents/local/bin/ack"
}

#colors
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)

#Loop through all the passed arguments
while [ -n "$1" ]; do
    case "$1" in 
        -a | --ack )
            install_ack;;
    esac
    shift
done

