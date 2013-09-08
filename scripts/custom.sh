#!/bin/bash

function install_ack {
    if [[ -d ${HOME}/Documents/local/bin ]]; then
        echo "The home directory already exists"
    else
        mkdir -p ${HOME}/local/bin
    fi
    wget -O "${HOME}/Documents/local/bin/ack" http://beyondgrep.com/ack-2.08-single-file 
    chmod u+x "${HOME}/Documents/local/bin/ack"
}

while [[ -n "$1" ]]; do
    case "$1" in 
        -a | --ack )
            install_ack;;
        -j | --autojump)
            install_autojump;;
    esac
    shift
done

