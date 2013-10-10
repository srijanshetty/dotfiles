# Debug messages 
NORMAL=$(tput sgr0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput smso; tput setaf 3)
UNDERLINE_ON=$(tput smul)
UNDERLINE_OFF=$(tput rmul)

# function to output messages on the console
function fail() {
        echo "[${RED} FAIL ${NORMAL}] $*"
}

function warn() {
        echo "[ ${YELLOW}WARN${NORMAL} ] $*"
}

function success() {
        echo "[${GREEN} OKAY ${NORMAL}] $*"
}

function highlight() {
        echo "${UNDERLINE_ON}$*${UNDERLINE_OFF}" 
}
