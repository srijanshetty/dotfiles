#!/bin/bash
# Script to update chrome

# Update function
function download {
    # Going to the usr bin directory
    if [ -e ~/Documents/bin/ ]; then
        cd ~/Documents/bin/
    else
        mkdir -p "~/Documents/bin"
        cd "~/Documents/bin/"
    fi
    
    echo ""
    echo "**********              Downloading Source             **********"
    echo ""
    if wget https://download-chromium.appspot.com/dl/Linux_x64 -O chromium.zip; then
        echo "**********              Unpacking Source            **********"
        unzip chromium.zip
        rm chromium.zip
    fi

    # Head back to the current directory
    cd $PDIR
}

# Install function
function install {
    echo ""
    echo "******************************************************************" 
    echo "**********              Installing Chromium             **********"
    echo "******************************************************************"
    echo ""

    # Download the source
    download 

    #ADD the sandbox step
}


PDIR=${pwd}
# Add an initialization command and modify alias
case "$1" in 
    install ) 
        install ;;
    * ) 
        echo "******************************************************************"
        echo "*********               Updating Chromium              ***********"
        echo "******************************************************************"
        echo ""
        download ;;
esac
