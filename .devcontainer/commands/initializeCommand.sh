#!/bin/bash -e

CMDDIR=$(cd $(dirname $0); pwd)
DCDIR=$(dirname $CMDDIR)
export DIR="$(dirname $DCDIR)"
source "$CMDDIR/log.sh"

user="$1"

log "Start initialize command"
log "  container user : $user"

env='./.devcontainer/tmp/.env.devcontainer'
: > "$env"

log "Create .env: $env"

# GitHub CLI用の認証情報を取得
if which gh &> /dev/null; then
    GH_TOKEN=$(gh auth token)
    if [ -z "$GH_TOKEN" ]; then
        log -w "Skip authentication because gh auth token is empty."
    else
        log "Setup GitHub CLI authentication."
        echo "GH_TOKEN=${GH_TOKEN}" > "$env"
    fi
else
    log -w "GitHub CLI is not installed. Skipping authentication."
fi

# Gemini CLI用のワークスペースの作成
mkdir -p "$DCDIR/tmp/.gemini/tmp"

LSCRIPT="$CMDDIR/initializeCommand.local.sh"
if [ -x "$LSCRIPT" ]; then
    log "Run local script: $(basename $LSCRIPT)"
    $LSCRIPT "$user" "$env"
else
    log -w "Local script is not found or not runnable: $LSCRIPT"
fi
