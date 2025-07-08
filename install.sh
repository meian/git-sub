#!/bin/bash -eu

DIR=$(cd $(dirname ${BASH_SOURCE}); pwd)
. $DIR/common.sh || exit 1

usage() {
    logcat << EOU
$DIR/install.sh [--auto|--bash|--zsh] [-f]

args:
  --auto : \$SHELL 変数から --bash または --zsh を判別してインストールする
  --bash : bashに対してインストールする(~/.bashrc)
  --zsh  : zshに対してインストールする(~/.zshrc)
  -f     : subpingの認識チェックを行わないでインストールする(再インストール等で使用)
EOU
    exit 2
}

mode="${1:-}"
[ -n "$mode" ] || usage

if [ "$mode" == "--auto" ] ; then
    echo $SHELL | command grep zsh > /dev/null && mode="--zsh" || mode="--bash"
    logcat << EOE
mode = $mode
To install to selected shell, use args "--bash" or "--zsh"
Current install mode: $mode
EOE
fi

[[ $mode =~ ^(--zsh|--bash)$ ]] || {
    log "invalid option: $*"
    usage
}

if [ "${2:-}" != "-f" ] ; then
    if command git subping > /dev/null 2>&1 ; then
        log 'Already installed.'
        command git subping >&2
        exit 0
    fi
fi

rc=.bashrc
if [ $mode == "--zsh" ] ; then
    rc=.zshrc
fi

rc="${HOME:?not found home dir.}/$rc"
if [ -f "$rc" ] ; then
    if command grep "$DIR" $rc > /dev/null ; then
        log "already set PATH? try command"
        log "  source . $rc"
        exit 3
    fi
fi

CMPL="$DIR/.bash_completion"
command cat << EOF >> $rc
export PATH=\$PATH:$DIR
if [ -x "$CMPL" ] ; then
    . $CMPL
fi
EOF

logcat << EOC
Install git-sub is completed.
try below commands.
  source $rc
  git subping
EOC
