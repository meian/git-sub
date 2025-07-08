#!/bin/bash -e

CMDDIR=$(cd $(dirname $0); pwd)
DCDIR=$(dirname $CMDDIR)
export DIR="$(dirname $DCDIR)"
source "$CMDDIR/log.sh"

user="$1"

log "Start post create command: container user=$user"

bashrc="/home/$user/.bashrc"

# プロンプト
command cat <<'PROMPT' >> $bashrc
export PS1='$(export XIT=$? && echo -n "\[\033[0;32m\]\u " && [ "$XIT" -ne "0" ] && echo -n "\[\033[1;31m\]➜" || echo -n "\[\033[0m\]➜" \
) \[\033[1;34m\]\w\[\033[31m\]$(__git_ps1)\[\033[00m\]\$ '
export PROMPT_DIRTRIM=2
PROMPT

# エイリアスは他にも必要であれば postCreateCommand.local.sh で追加すること
aliases="/home/$user/.aliases"
command cat <<EOF > $aliases
alias ll='ls -l --color=auto'
EOF
echo ". $aliases" >> $bashrc

# nodeのグローバルモジュールのインストール先を変更
command sudo chown $user:$user /home/vscode/.global_node_modules
command npm config set prefix /home/$user/.global_node_modules
echo "export PATH=\$PATH:/home/$user/.global_node_modules/bin" >> /home/$user/.bashrc
export PATH=$PATH:/home/$user/.global_node_modules/bin

# gitの補完とプロンプト
command cat <<'GIT' >> $bashrc
source /usr/share/bash-completion/completions/git
source /etc/bash_completion.d/git-prompt
GIT_PS1_SHOWDIRTYSTATE=true
GIT

command git config --global codespaces-theme.hide-status 1

# initializeでコミット関連の情報を設定している場合は追加のgit設定
log "Git information from environment variables:"
log "  GITUSER : ${GITUSER}"
log "  GITMAIL : ${GITMAIL}"
log "  GPGNAME : ${GPGNAME}"

if [ -n "$GITUSER" ] ; then
    if [ -n "$GITMAIL" ]; then
        log "Setup git user with mail: $GITUSER - $GITMAIL"
        command git config --global user.name $GITUSER
        command git config --global user.email $GITMAIL
    elif [ -n "$GPGNAME" ] ; then
        signkey=$(command gpg --list-keys --with-colons $GPGNAME | command grep '^pub' | command cut -d: -f5)
        mail=$(command gpg --list-keys --with-colons $signkey | command awk -F: '/^uid:/ {print $10}' | command cut -d'<' -f2 | command cut -d'>' -f1)
        log "Setup git user with GPG: $GITUSER - $signkey - $mail"
        command git config --global user.name $GITUSER
        command git config --global user.email $mail
        command git config --global user.signingkey $signkey
        command git config --global commit.gpgsign true
        command git config --global tag.gpgsign true
    fi
fi

# githubのGPGキーをインポート
command curl https://github.com/web-flow.gpg | command gpg --import

LSCRIPT="$CMDDIR/postCreateCommand.local.sh"
if [ -x "$LSCRIPT" ]; then
    log "Run local script: $(command basename $LSCRIPT)"
    $LSCRIPT $user
else
    log -w "Local script is not found or not runnable: $LSCRIPT"
fi
