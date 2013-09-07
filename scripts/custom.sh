#!/bin/bash

function install_ack {
    if [[ -d ${HOME}/Documents/GitHub ]]; then
        echo "The home directory already exists"
    else
        mkdir -p ${HOME}/GitHub
    fi
    wget -O "${HOME}/Documents/GitHub/ack" http://beyondgrep.com/ack-2.08-single-file 
    chmod u+x "${HOME}/Documents/GitHub/ack"
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

