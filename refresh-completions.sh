#!/bin/bash -eu

# .bash_completionを最新化するコマンド
#   git-*のスクリプトに
#   # completion: コマンド名
#   # completion: コマンド名 : エイリアス名
#   のいずれかを記述すると.bash_completionに補完用のスクリプトを出力する

DIR=$(cd $(dirname ${BASH_SOURCE}); pwd)
. $DIR/common.sh || exit 1

CMPL=$DIR/.bash_completion

cat << EOF > $CMPL
#/bin/bash

if [[ \$SHELL =~ "bash" ]] ; then
    if [ "\$(type -t __git)" != 'function' ] ; then
        echo 'git is not installed' >&2
        return
    fi
elif [[ \$SHELL =~ "zsh" ]] ; then
    # zshでのgit-completionのチェックがやり方よくわらかなかったので、bashスクリプトあれば動くものとしている
    gitdir="\$(dirname \$(dirname \$(readlink -f \$(which git))))"
    if [ -z "\$gitdir" ] ; then
        return
    fi
    comp_bash="\$gitdir/etc/bash_completion.d/git-completion.bash"
    if [ ! -f "\$comp_bash" ] ; then
        echo 'git-completion is not installed' >&2
        return
    fi
    if which autoloiad > /dev/null ; then
        autoload -U compinit
        compinit -u
    fi
else
    # bash/zsh以外は動かさない
    return
fi
EOF

(
    cd $DIR

    grep '# completion: ' git* | sed -E 's/# completion://; s/\s*:\s*/ /g' | while read cmd call ; do
        func="_${cmd//-/_}"
        cat << FUNC

# for "${cmd/-/ }"
$func() {
    $call
}
FUNC
    done >> $CMPL

    grep '# alias: ' git* | sed -E 's/.+# alias://; s/\s*:\s*/ /g' | while read alias call ; do
        func="_git_${alias//-/_}"
        cat << ALIAS

# for "git $alias"
$func() {
    $call
}
ALIAS
    done >> $CMPL
)

chmod +x $CMPL
