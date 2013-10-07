# Debug messages 
NORMAL=$(tput sgr0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)

# function to output messages on the console
function fail() {
        echo "[${RED} FAIL ${NORMAL}] $*"
}

function warn() {
        echo "[${RED} WARN ${NORMAL}] $*"
}

function success() {
        echo "[${GREEN} OKAY ${NORMAL}] $*"
}
