#!/bin/bash -eu

DIR=$(cd $(dirname ${BASH_SOURCE}); pwd)
. $DIR/common.sh || exit 1

alias_path="$DIR/.git-alias"

[ -f "$alias_path" ] || {
    cp -p "$alias_path.example" "$alias_path"
    log "create alias config from example: $alias_path"
}

git config --global --list | grep include.path | grep "$alias_path" > /dev/null && {
    log "already installed aliases : $alias_path"
    exit 0
}

git config --global --add include.path $alias_path && {
    log "install alias is complete."
} || {
    log "install alias is failed."
    exit 2
}
