#!/bin/bash

NORMAL=$(tput sgr0)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)

function red() {
    echo -n "$RED$*$NORMAL"
}

function green() {
    echo -n "$GREEN$*$NORMAL"
}

function yellow() {
    echo -n "$YELLOW$*$NORMAL"
}
