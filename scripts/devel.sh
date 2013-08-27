#!/bin/zsh

function install_lamp {
	sudo apt-get install -y apache2 mysql-server mysql-client phpmyadmin
}

function install_tools {
	sudo apt-get install -y ack-grep curl texlive filezilla
}

function install_chrome {
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O temp.deb && sudo dpkg -i temp.deb
    if [ -e temp.deb ]; then
        rm -rf temp.deb
    fi
}

function install_node {
    sudo add-apt-repository ppa:chris-lea/node.js && sudo apt-get update
    sudo apt-get -y install nodejs
    sudo ./npm.sh
}

function install_sublime {
    wget http://c758482.r82.cf2.rackcdn.com/sublime-text_build-3047_amd64.deb -O temp.deb && sudo dpkg -i temp.deb
    if [ -e temp.deb ];
        rm -rf temp.deb
    fi
    # link sublime files
}

function install_yeoman {
    # check for the existence of npm
    npm install -g yo
}
# Add for sublime
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
        *) echo "tools,lamp";;
    esac
    shift
done

