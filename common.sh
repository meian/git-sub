#!/bin/bash

set -euo pipefail

log() {
    echo "$@" >&2
}
export -f log

logcat() {
    command cat - >&2
}
export -f logcat

# logと実装が同じだが用途が違うので個別で定義する
err() {
    echo "$@" >&2
}
export -f err

command git help > /dev/null 2>&1 || {
    log 'git is not installed.'
    exit 1
}

export FZF_DEFAULT_OPTS='--height 70% --border --reverse'

require_fzf() {
    command fzf -h > /dev/null || {
        log 'fzf is required.'
        exit 1
    }
}
export -f require_fzf
