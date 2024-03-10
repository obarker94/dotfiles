#!/bin/bash

SESSION_NAME=$1

if [ -z "$SESSION_NAME" ]; then
    echo "Usage: $0 <session_name>"
    exit 1
fi

SESSION_FILE=~/.config/tmux/sessions/$SESSION_NAME.tmuxsession

tmux list-windows -a > "$SESSION_FILE"

echo "Session '$SESSION_NAME' saved or overwritten."

