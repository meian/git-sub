#!/bin/bash -e

log() {
    local color reset msg now
    color="\033[0;32m" # green
    reset="\033[0m"
    if [[ "$1" == "-w" ]]; then
        color="\033[0;33m" # yellow
        shift
    elif [[ "$1" == "-e" ]]; then
        color="\033[0;31m" # red
        shift
    fi
    msg="$*"
    now=$(date +"%H:%M:%S")
    echo -e "${color}[${now}] ${msg}${reset}" >&2
}

export -f log
