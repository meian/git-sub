#!/bin/bash -eu

DIR=$(cd $(dirname ${BASH_SOURCE}); pwd)
. $DIR/common.sh || exit 1

alias_path="$DIR/.git-alias"

[ -f "$alias_path" ] || {
    command cp -p "$alias_path.example" "$alias_path"
    log "create alias config from example: $alias_path"
}

command git config --global --list | command grep include.path | command grep "$alias_path" > /dev/null && {
    log "already installed aliases : $alias_path"
    exit 0
}

command git config --global --add include.path $alias_path && {
    log "install alias is complete."
} || {
    log "install alias is failed."
    exit 2
}
