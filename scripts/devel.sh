#!/bin/zsh

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

#Install node
function install_yeoman {
    if hash node &> /dev/null; then 
        npm install -g yo 
    else
        fail "Node is not installed. Install node and retry"
    fi
}

#source the installation files
source helper.sh

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
