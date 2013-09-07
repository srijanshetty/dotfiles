#!/bin/zsh

function install_node {

}

function install_ack {
    if [[ -d ${HOME}/local/bin ]]; then
        echo "The home directory already exists"
    else
        mkdir -p ${HOME}/local/bin
    fi
    wget -O "${HOME}/local/bin/ack" http://beyondgrep.com/ack-2.08-single-file 
    #change the permission of the ack file
}

function install_lamp {
	sudo apt-get install -y apache2 mysql-server mysql-client phpmyadmin
}

function install_tools {
	sudo apt-get install -y curl texlive filezilla
}

function install_chrome {
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O temp.deb && sudo dpkg -i temp.deb
    if [ -e temp.deb ]; then
        rm -rf temp.deb
    fi
}

function install_sublime {
    wget http://c758482.r82.cf2.rackcdn.com/sublime-text_build-3047_amd64.deb -O temp.deb && sudo dpkg -i temp.deb
    if [ -e temp.deb ]; then
        rm -rf temp.deb
    fi
    # link sublime files
}

function install_yeoman {
    # check for node
    # check for the existence of npm
    npm install -g yo
}

while [ -n "$1" ]; do
    case "$1" in 
        -t | --tools) 
            install_tools;;
        -l | --lamp) 
            install_lamp;;
        -c | --chrome)
            install_chrome;;
        -n | --node)
            install_node;;
        -a | --ack)
            install_ack;;
        *) echo "tools,lamp";;
    esac
    shift
done

